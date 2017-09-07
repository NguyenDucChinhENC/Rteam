class ApiConstraints
  def initialize option
    @version = option[:version]
    @default = option[:default]
  end

  def matches? req
    @default || req.headers["Accept"].include?("application/my-stories.v#{@version}")
  end
end