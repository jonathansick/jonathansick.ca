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
            self.data["pubs"] = self.get_publications(site)
            puts self.data
        end

        def get_publications(site)
            # This itererator emits the YAML hash of each publication file.
            puts "in get_publications()"
            {}.tap do |publications|
                Dir['_publications/*.yml'].each do |path|
                    name = File.basename(path, '.yml')
                    puts name
                    config = YAML.load(File.read(File.join(@base, path)))
                    puts config
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
