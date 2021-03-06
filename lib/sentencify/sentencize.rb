require 'active_support/core_ext/array'

class Array
  def sentencize(options = {})
    assert_sentenciable options

    default_connectors = {
      image:                    false,
      limit:                    5,
      empty:                    'No element found',
      words_connector:          ', ',
      two_words_connector:      ' and ',
      last_word_connector:      ' and ',
      final_singular_connector: ' other',
      final_plural_connector:   ' others'
    }

    if defined?(I18n)
      i18n_connectors = I18n.translate(:sentencify, default: {})
      default_connectors.merge! i18n_connectors
    end

    options           = default_connectors.merge! options
    will_sentencized  = self.dup
    will_sentencized  = will_sentencized.map! { |o| o[options[:on]] } if options[:on] && !options[:image]

    case length
    when 0
      options[:empty]
    when 1
      will_sentencized[0]
    when 2
      "#{will_sentencized[0]}#{options[:two_words_connector]}#{will_sentencized[1]}"
    else
      if options[:limit] >= length
        "#{will_sentencized[0...-1].join(options[:words_connector])}#{options[:last_word_connector]}#{will_sentencized[-1]}"
      else
        nb_others = length - options[:limit]
        others    = (nb_others != 1) ? options[:final_plural_connector] : options[:final_singular_connector]
        "#{will_sentencized[0..options[:limit]-1].join(options[:words_connector])}#{options[:last_word_connector]}#{nb_others}#{others}"
      end
    end
  end

private

  def assert_sentenciable(options = {})
    options.assert_valid_keys(:on, :image, :limit, :empty, :words_connector, :two_words_connector, :last_word_connector, :final_singular_connector, :final_plural_connector)
  end
end
