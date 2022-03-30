# Responsible for creating cute logs

require "colorize"
require "log"

# Log format
Formatter = Log::Formatter.new do |entry, io|
  io << (entry.severity.fatal? || entry.severity.error? ? "❌" : "ℹ️") << " " << entry.message
end
Log.setup(level: :warn, backend: Log::IOBackend.new(formatter: Formatter))

module Pog::Logger
  extend self

  LOGGER = Log.for("Pog", Log::Severity::Warn)

  # [MACRO] Create log level functions from the hash
  # eg. def error(message : String)
  #       LOGGER.error { message.colorize({{color}}).mode(:bold) }
  #       exit(1)
  #     end
  macro create_log_levels(levels)
    {% for level, color in levels %}
      def {{level.id}}(message : String)
        LOGGER.{{level.id}} { message.colorize({{color}}).mode(:bold) }
        # [MACRO] Exit with 1 on error or fatal log
        {% if "#{level.id}" == "error" || "#{level.id}" == "fatal" %}
            exit(1)
        {% end %}
      end
    {% end %}
  end

  create_log_levels({
    error: :red,
    fatal: :red,
    # Unused atm
    # warn:  :yellow,
    # info:  :green,
    # debug: :light_gray,
  })

  # Status log (most common)
  def status(message : String, alt : Bool = false)
    # [MACRO] Don't log on spec
    {% unless @top_level.has_constant? "Spec" %}
      STDOUT.puts "🍋 #{message.colorize(alt ? :green : :yellow).mode(:bold)}"
    {% end %}
  end
end
