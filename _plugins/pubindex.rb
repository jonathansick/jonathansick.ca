require 'date'

module Jekyll
    class PublicationsPage < Page
        def initialize(site, base, dir)
            @site = site
            @base = base
            @dir = dir
            @name = "publications.html"
            puts "In PublicationsPage.initialize()"

            self.process(@name)
            self.read_yaml(File.join(base, "_layouts"), "publications.html")
            self.data["published"] = self.get_published(site)
            self.data["unpublished"] = self.get_unpublished(site)
            self.data["conference"] = self.get_conference(site)
            self.data["talks"] = self.get_talks(site)
            self.data["theses"] = self.get_theses(site)
            # puts self.data
            puts self.data["published"]
        end

        def get_published(site)
            # This itererator emits the YAML hash of each publication file.
            {}.tap do |publications|
                Dir['_publications/published/*.yml'].each do |path|
                    name = File.basename(path, '.yml')
                    config = YAML.load(File.read(File.join(@base, path)))
                    puts path
                    # Can't get strptime to work :(
                    # puts Date.strptime(config['date'], "%Y-%m-%d")
                    d =  Date.new(config['year'], config['month'], config['day'])
                    puts d
                    config['date'] = d
                    publications[name] = config
                end
            end
        end

        def get_unpublished(site)
            # This itererator emits the YAML hash of each publication file.
            {}.tap do |publications|
                Dir['_publications/unpublished/*.yml'].each do |path|
                    name = File.basename(path, '.yml')
                    config = YAML.load(File.read(File.join(@base, path)))
                    publications[name] = config
                end
            end
        end

        def get_conference(site)
            # This itererator emits the YAML hash of each publication file.
            {}.tap do |publications|
                Dir['_publications/conference/*.yml'].each do |path|
                    name = File.basename(path, '.yml')
                    config = YAML.load(File.read(File.join(@base, path)))
                    publications[name] = config
                end
            end
        end

        def get_talks(site)
            # This itererator emits the YAML hash of each publication file.
            {}.tap do |publications|
                Dir['_publications/talks/*.yml'].each do |path|
                    name = File.basename(path, '.yml')
                    config = YAML.load(File.read(File.join(@base, path)))
                    publications[name] = config
                end
            end
        end

        def get_theses(site)
            # This itererator emits the YAML hash of each publication file.
            {}.tap do |publications|
                Dir['_publications/theses/*.yml'].each do |path|
                    name = File.basename(path, '.yml')
                    config = YAML.load(File.read(File.join(@base, path)))
                    publications[name] = config
                end
            end
        end
    end
    
    class PublicationsPageGenerator < Generator
        safe true
        priority :normal

        def generate(site)
            puts "Running PublicationsPageGenerator"
            # if Dir.exists?('_publications')
            puts "has _publications/"
            self.write_publications_page(site)
            # end
        end

        # Loop through list of publications and process each one
        def write_publications_page(site)
            Dir.chdir(site.source)
            publications_page = PublicationsPage.new(site, site.source, "/")
            publications_page.render(site.layouts, site.site_payload)
            publications_page.write(site.dest)
            site.pages << publications_page
            site.static_files << publications_page
        end
    end
end
