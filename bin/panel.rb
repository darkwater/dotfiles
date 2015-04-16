#!/usr/bin/env ruby

class Monitor
    @monitors = []
    @monitors_by_name = {}

    def self.add(instance)
        @monitors << instance
        @monitors_by_name[instance.name] = instance
    end

    def self.[](n)
        case n
        when Integer
            @monitors[n]
        when String
            @monitors_by_name[n]
        end
    end

    def self.all
        @monitors
    end

    def self.each
        @monitors.each { |m| yield m }
    end

    def initialize(name, res, pos)
        @name = name
        @res = res.split 'x', 2
        @pos = pos.split '+', 2

        @res.map! { |n| n = n.to_i }
        @pos.map! { |n| n = n.to_i }

        Monitor.add self
    end

    def create_panel
        @panel ||= Panel.new self
    end

    attr_reader :panel, :name
    def x; @pos[0] end
    def y; @pos[1] end
    def w; @res[0] end
    def h; @res[1] end

    def to_s
        "Monitor #{@name} #{@res.join 'x'} #{@pos.join '+'}"
    end
end

class Panel
    def initialize(monitor)
        @monitor = monitor
        @dzen = open '|dzen2 -y -1 -h 2 -ta l -e "button2=;"', 'w+'

        @width = monitor.w
        @desktops = `bspc query -m #{monitor.name} -D`.lines.size
    end

    def draw(items)
        item_width = @width / items.size
        items.each { |item| @dzen.write "^fg(#{item})^r(#{item_width}x2)" }
        @dzen.puts
    end
end

Monitor.new 'VGA1', '1200x1920', '0+0'

Monitor.each { |m| m.create_panel }

bspc = open '|bspc control --subscribe', 'r'
bspc.each_line do |line|
    puts line

    case line[0]
    when 'W'
        monitor = nil
        items = []

        line[1..-1].split(':').each do |item|
            name = item[1..-1]

            case item[0]
            when 'M', 'm'
                monitor = Monitor[name]
            when 'O', 'U' # occupied active (or urgent active, shouldn't happen)
                items << '#00abcd'
            when 'F' # free active
                items << '#405060'
            when 'o' # occupied inactive
                items << '#003050'
            when 'f' # free inactive
                items << '#1d1f21'
            when 'u' # urgent inactive
                items << '#ffaf00'
            when 'L' # layout; end of desktops
                monitor.panel.draw items unless monitor == nil
            end
        end
    end
end
