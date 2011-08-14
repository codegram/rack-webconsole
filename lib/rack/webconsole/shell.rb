require 'ripl'

class Rack::Webconsole
  module Shell
    def self.eval_query(query)
      Ripl.shell.input = query
      Ripl.shell.loop_once
      Ripl.shell.return_result
    end

    # TODO: move to plugin
    def multi_line?
      @buffer.is_a?(Array)
    end

    def previous_multi_line?
      @old_buffer.is_a?(Array)
    end

    def get_input
      @old_buffer = @buffer
      history << @input
      @input
    end

    def loop_eval(query)
      # Force conversion to symbols due to issues with lovely 1.8.7
      boilerplate = local_variables.map(&:to_sym) + [:ls]

      $sandbox.instance_eval """
        result = (#{query})
        ls = (local_variables.map(&:to_sym) - [#{boilerplate.map(&:inspect).join(', ')}])
        @locals ||= {}
        @locals.update(ls.inject({}) do |hash, value|
          hash.update({value => eval(value.to_s)})
        end)
        result
      """
    end

    def print_eval_error(err)
      @result = "Error: " + err.message
    end

    def return_result
      @error_raised ? result : result.inspect
    end

    # Disable unused callbacks
    def print_result(result) end
    def before_loop() end
  end
end

# Disable readline's #get_input
Ripl.config[:readline] = false
# Let ripl users detect web shells
Ripl.config[:web] = true
Ripl::Shell.include Rack::Webconsole::Shell
# must come after Webconsole plugin
require 'ripl/multi_line'
# Initialize ripl plugins
Ripl.shell.before_loop
