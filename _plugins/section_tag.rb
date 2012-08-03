module Jekyll
  class SectionTag < Liquid::Tag

    def initialize(tag_name, section, tokens)
      super
      @section = section.strip
    end

    def render(context)
      includes_dir = File.join(context.registers[:site].source, '_sections')
      if File.symlink?(includes_dir)
        return "Includes directory '#{includes_dir}' cannot be a symlink"
      end
      if @section !~ /^[a-zA-Z0-9_\/\.-]+$/ || @section =~ /\.\// || @section =~ /\/\./
        return "Include file '#{@section}' contains invalid characters or sequences"
      end

      Dir.chdir(includes_dir) do
        choices = Dir['**/*'].reject { |x| File.symlink?(x) }
        if choices.include?(@section)
          source = File.read(@section)
          partial = Liquid::Template.parse(source)
          context.stack do
            partial.render(context)
          end
        else
          "Included file '#{@section}' not found in _sections directory"
        end
      end
    end
  end
end

Liquid::Template.register_tag('section', Jekyll::SectionTag)
