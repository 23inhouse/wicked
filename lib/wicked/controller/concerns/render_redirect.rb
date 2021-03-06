module Wicked::Controller::Concerns::RenderRedirect
  extend ActiveSupport::Concern


  # scary and gross, allows for double render
  def _reset_invocation_response
    self.instance_variable_set(:@_response_body, nil)
    response.instance_variable_set :@header, Rack::Utils::HeaderHash.new("cookie" => [], 'Content-Type' => 'text/html')
  end


  def render_wizard(resource = nil)
    _reset_invocation_response
    @skip_to = @next_step if resource && resource.save
    if @skip_to.present?
      redirect_to wizard_path @skip_to
    else
      render_step  @step
    end
  end

  def render_step(the_step)
    if the_step.nil? || the_step == :finish
      redirect_to_finish_wizard
    else
      render the_step
    end
  end

  def redirect_to_next(next_step)
    if next_step.nil?
      redirect_to_finish_wizard
    else
      redirect_to wizard_path(next_step)
    end
  end

  def finish_wizard_path
    '/'
  end

  def redirect_to_finish_wizard
    redirect_to finish_wizard_path
  end

end
