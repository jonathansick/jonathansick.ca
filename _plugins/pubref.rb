# References to publications mae by pubindex generator
# Use these on the homepage to call out recent papers/talks

module Jekyll
    class PubRefTag < Liquid::Tag
        def initialize(tag_name, text, tokens)
            super
            # @text = text
            @fname = text.strip
            puts "initialize PubRefTag"
            puts tag_name
            puts @fname
        end

        def render(context)
            site = context.registers[:site]
            # Get type of publication from filename
            pubType = @fname.split('/').first
            # Make full path to yml in _publications/ dir
            fullPath = File.join(site.config['source'], "_publications/" + @fname)
            # Load publication YAML
            pubData = YAML.load(File.read(fullPath))
            key = File.basename(fullPath, '.yml')
            "<a class='pubref-title' href='/publications.html/##{key}'>#{pubData['title']}</a>"
        end
    end
end

Liquid::Template.register_tag('pubref', Jekyll::PubRefTag)
