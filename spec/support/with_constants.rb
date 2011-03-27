# Borrowing Rails monkeypatch: http://api.rubyonrails.org/classes/Kernel.html
module Kernel
  def silence_warnings
    with_warnings(nil) { yield }
  end

  def with_warnings(flag)
    old_verbose, $VERBOSE = $VERBOSE, flag
    yield
  ensure
    $VERBOSE = old_verbose
  end
end

# From: http://digitaldumptruck.jotabout.com/?p=551
def with_constants(constants, &block)
  saved_constants = {}
  constants.each do |constant, val|
    saved_constants[ constant ] = Object.const_get( constant )
    Kernel::silence_warnings { Object.const_set( constant, val ) }
  end
 
  begin
    block.call
  ensure
    constants.each do |constant, val|
      Kernel::silence_warnings { Object.const_set( constant, saved_constants[ constant ] ) }
    end
  end
end

def with_environment_variable(variables, &block)
  saved_variables = {}
  
  variables.each do |variable, value|
    saved_variables[variable] = ENV[variable]
    Kernel::silence_warnings { ENV[variable] = value }
  end
  begin
    block.call
  ensure
    variables.each do |variable, value|
      Kernel::silence_warnings { ENV[variable] = saved_variables[variable] }
    end
  end
end