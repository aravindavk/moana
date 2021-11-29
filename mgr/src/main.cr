require "option_parser"

require "./cmds/*"

VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}

module CLI
  def self.run(args)
    parsed = Args.new
    parsed.url = ENV.fetch("KADALU_URL", "http://localhost:3000")

    parser = OptionParser.new do |parser_1|
      parser_1.banner = "Usage: kadalu [subcommand] [arguments]"
      parser_1.on("-h", "--help", "Show this help") do
        puts parser_1
        exit
      end

      parser_1.on("--version", "Show Version information") do
        puts "kadalu #{VERSION}"
        exit
      end

      parser_1.on("version", "Show Version information") do
        puts "kadalu #{VERSION}"
        exit
      end

      Commands.commands.each do |name, cmd|
        parser_1.on(name, cmd.help) do
          subcmds = Commands.sub_commands(name)
          if subcmds
            subcmds.each do |s_name, s_cmd|
              parser_1.on(s_name, s_cmd.help) do
                parsed.cmd = "#{name}.#{s_name}"
                s_proc = s_cmd.proc
                s_proc.call(parser_1, parsed) if s_proc
              end
            end
          else
            parsed.cmd = name
            proc = cmd.proc
            proc.call(parser_1, parsed) if proc
          end
        end
      end
    end

    parser.unknown_args do |pargs|
      parsed.pos_args = pargs
    end

    parser.invalid_option do |flag|
      STDERR.puts "Invalid Option: #{flag}"
      exit 1
    end

    parser.missing_option do |flag|
      STDERR.puts "Missing Option value: #{flag}=VALUE"
      exit 1
    end

    parser.parse(args)

    # Try execute only if handler is defined
    if Commands.handlers[parsed.cmd]?
      Commands.handlers[parsed.cmd].call(parsed)
    elsif parsed.cmd == ""
      puts parser
      exit 0
    else
      STDERR.puts "Unknown command \"#{args.join(" ")}\""
      exit 1
    end
  end
end

CLI.run(ARGV)