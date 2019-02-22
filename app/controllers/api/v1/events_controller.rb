class Api::V1::EventsController < Api::BaseController
  before_action :find_object, only: %i(show update destroy).freeze
  before_action :authenticate_with_token!, only: %i(index create update destroy).freeze

  def index
    render json: {
      data: {
        events: all_events,
        events_comming: events_comming
      }
    }, status: :ok
  end

  def show
    if event.status
      show_event
    end
  end

  def create
    byebug
    if params[:id_group]
      group = Group.find_by id: params[:id_group]
      if check_admin_group params[:id_group]
        @event = group.events.new event_params
        if @event.save
          @admin_event = @event.admin_events.new(user_id: @current_user.id)
          if @admin_event.save
            show_event
          else
            @event.destroy
            error_create
          end
        else
          error_create
        end
      end
    end
  end

  def update
    if check_admin_event event.id
      if event.update_attributes event_params
        render_json_success("Update Success", event)
      else
        render_json_not_success(event.errors.full_messages, 405)
      end
    else
      render_json_not_success("You can't update this event", 406)
    end
  end

  def destroy
    if check_admin_event event.id
      time_now = Time.now
      if event.time > time_now
        render json: {
          messeges: time_now, 
          m: event.time
        }
      end
    end
  end

  attr_reader :event, :group, :events

  private

  def event_params
    params.require(:event).permit Event::ATTRIBUTES_PARAMS
  end

  def all_events
    events = []
    member_events = @current_user.member_event
    member_events.each do |m|
      events.push event_serializer(m.event, @current_user.id)
    end
    events.uniq
    events = events.sort_by{|e| e[:created_at]}.reverse
  end

  def events_comming
    events_comming = []
    member_events = @current_user.member_event
    member_events.each do |m|
      event = Event.find_by id: m.event_id
      if event.time > Date.today
        events_comming.push event_serializer(event, @current_user.id)
      end
    end
    events_comming
  end

  def show_event
    render json: {
      data: {event: event_show_serializer(event, @current_user.id)}
    }, status: :ok
  end

  def error_create
    render json: {
      error: @event.errors.full_messages
    }, status: 404
  end

  def event_show_serializer(event, id_user)
    Serializers::Events::EventsShowSerializer.new(object: event, id_user: id_user).serializer
  end

  def event_serializer(event, id_user)
    Serializers::Events::EventsSerializer.new(object: event, id_user: id_user).serializer
  end

end
