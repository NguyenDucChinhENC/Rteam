class Api::V1::EventsController < Api::BaseController
  before_action :find_object, only: %i(show update destroy).freeze
  before_action :authenticate_with_token!, only: %i(index create update destroy).freeze

  def index
    member_events = @current_user.member_event
    tmp_events = []
    tmp_events_comming = []
    member_events.each do |m|
      event = Event.find_by id: m.event_id
      tmp_events.push event_serializer(event, @current_user.id)
      if event.time > Date.today
        tmp_events_comming.push event_serializer(event, @current_user.id)
      end
    end
    tmp_events.uniq
    tmp_events = tmp_events.sort_by{|e| e[:created_at]}.reverse
    render json: {
      data: {
        events: tmp_events,
        events_comming: tmp_events_comming
      }
    }, status: :ok
  end

  def show
    if event.status
      show_event
    end
  end

  def create
    if params[:id_group]
      group = Group.find_by id: params[:id_group]
      if check_admin_group
        @event = group.events.new event_params
        # byebug
        if @event.save
          @admin_event = @event.admin_events.new(user_id: @current_user.id)
          if @admin_event.save
            show_event
          else
            @event.destroy
            error_create
          end
        else
          # byebug
          error_create
        end
      end
    end
  end

  def update
    if check_admin_event
      if event.update_attributes event_params
        render json: {
          messeges: "Update Success",
          event: event
        }, status: :ok
      else
        render json: {
          messeges: event.errors.full_messages
        }, status: 405
      end
    else
      render json: {
        messeges: "You can't update this event"
      }, status: 406
    end
  end

  def destroy
    if check_admin_event
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

  def show_event
    render json: {
      data: {event: event_show_serializer(event, @current_user.id)}
    }, status: :ok
  end

  def error_create
    # byebug
    render json: {
      # messeges: "Error on create",
      error: @event.errors.full_messages
    }, status: 404
  end

  def check_admin_group
    MemberGroup.find_by_membergrouptable_id_and_id_group(@current_user.id, params[:id_group]).admin
  end

  def check_admin_event
    if AdminEvent.find_by_event_id_and_user_id(params[:id], @current_user.id)
      return true
    else
      return false
    end
  end

  def event_show_serializer(event, id_user)
    Serializers::Events::EventsShowSerializer.new(object: event, id_user: id_user).serializer
  end

  def event_serializer(event, id_user)
    Serializers::Events::EventsSerializer.new(object: event, id_user: id_user).serializer
  end

end
