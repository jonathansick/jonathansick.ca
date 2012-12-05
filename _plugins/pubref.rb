# References to publications mae by pubindex generator
# Use these on the homepage to call out recent papers/talks

module Jekyll
    class PubRefTag < Liquid::Tag
        def initialize(tag_name, text, tokens)
            super
            @text = text
        end

        def render(context)
            "#{@text} #{Time.now}"
        end
    end
end

Liquid::Template.register_tag('pubref', Jekyll::PubRefTag)
