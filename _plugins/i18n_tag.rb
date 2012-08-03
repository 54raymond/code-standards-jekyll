module Jekyll
  class I18NTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text.strip
    end

    def render(context)
      language = context.registers[:site].config['I18N'] || 'en'
      i18n_dir = File.join(
        context.registers[:site].source,
        context.registers[:site].config['i18n_dir'] || '_i18n'
      )
      content = File.read(File.join(i18n_dir, language + '.yml'))
      data = YAML.load(content)
      data.has_key?(@text) ? data.fetch(@text) : @text
    end
  end
end

Liquid::Template.register_tag('t', Jekyll::I18NTag)
