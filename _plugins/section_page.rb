# file name: section_page.rb
# description: generate the section of _sections/xx(language)/
# author: alswl
# update at: 2012-08-02

module Jekyll

  class SectionPage < Page
    def initialize(site, base, sections, language)
      @site = site
      @base = base
      @dir = ''
      @name = language + '.html'

      @site.config['I18N'] =  language

      self.process(@name)
      self.read_sections(File.join(base, '_sections'),
                         site.config['section_layout'], language,  sections)
      self.data['language'] = language

    end

    # Read the sections
    #
    # base - The String path to the dir containing the file.
    # name - The String filename of the file.
    # language: The Language of current sections
    # sections: The content of sections
    #
    # Returns nothing.
    def read_sections(base, layout, language, sections)
      self.content = "---\nlayout: #{layout}\n---\n"
      sections.each do |section|
        self.content += File.read(File.join(base, language, section))
      end

      begin
        if self.content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
          self.content = $POSTMATCH
          self.data = YAML.load($1)
        end
      rescue => e
      end

      self.data ||= {}
    end

  end

  class SectionPageGenerator < Generator
    safe false
    
    def generate(site)
      #dir = site.config['sections_dir'] || '_sections'
      sections = site.config['sections'] || []
      languages = site.config['languages'] || ['en']
      languages.each do |language|
        site.pages << SectionPage.new(site, site.source, sections, language)
      end
    end
  end

end
