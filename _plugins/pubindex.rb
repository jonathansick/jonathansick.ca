module Jekyll
    class PublicationsPage < Page
        def initialize(site, base, dir)
            @site = site
            @base = base
            @dir = dir
            @name = "publications.html"
            puts "Im a publications page"

            # self.process(@name)
            # self.read_yaml(File.join(base, "_layouts"), "publications.html")
            # self.data["projects"] = self.get_projects(site)
        end

        # def get_publications(site)
            # {}.tap do |publications|
                # Dir['_pubs/*.yml'].each do |path|
                    # name = File.basename(path, '.yml')
                    # config = YAML.load(File.read(File.join(@base, path)))
                    # publications[name] = config
                # end
            # end
        # end
    end
    
    class GeneratePublicationsPage < Generator
        safe true
        priority :normal

        def generate(site)
            puts "Running GeneratePublicationsPage"
            if Dir.exists?('_publications')
                puts "has _publications/"
                self.write_publicationspage(site)
            end
        end

        # Loop through list of publications and process each one
        def write_publicationspage(site)
            Dir.chdir(site.source)
            publications = PublicationsPage.new(site, site.source, "/")
            # publications.render(site.layouts, site.site_payload)
            # publications.write(site.dest)
            # site.pages << publications
            # site.static_files << publications
        end
    end
end
