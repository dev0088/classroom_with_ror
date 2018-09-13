# frozen_string_literal: true

module I18nHelper
  include ActionView::Helpers::UrlHelper

  # Converts markdown links in strings to html links
  def parse_markdown_link (str, link_options = {})
    # Matches Markdown link syntax into text and link
    match = str.match(/\[(.*)\]\((.*)\)/)
    return str if match.blank?

    raw($` + link_to($1, $2, link_options) + $') unless match.blank?
  end
end
