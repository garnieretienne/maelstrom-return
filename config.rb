###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

###
# Helpers
###

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

helpers do

  Item = Struct.new(:type, :path, :label)

  def relative_path(path)
    path.sub("source/", "")
  end

  def build_portfolio_wall
    portfolio_path = "source/portfolio"
    labels_paths = Dir["source/portfolio/**/"]
    media = {
      txt: :text,
      jpg: :image,
      gif: :image,
      mp3: :audio
    }

    items = []
    html = ""

    labels_paths.each do |label_path|
      label = File.basename(label_path)
      label = nil if label == File.basename(portfolio_path)

      media.each do |ext, type|
        Dir["#{label_path}*.#{ext}"].each do |path|
          items << Item.new(type, path, label)
        end
      end
    end

    items.shuffle.each { |item| html << item_tag(item) }

    html
  end

  def item_tag(item)
    content_tag(:div, class: "item item-#{item.type}") do
      content = ""
      content << self.send("#{item.type}_item_content", item)
      content << content_tag(:div, class: "label") { item.label } if item.label
      content
    end
  end

  private

  def text_item_content(item)
    content = content_tag(:h2) { File.basename(item.path, ".*") }
    content << content_tag(:p) { IO.read(item.path).gsub("\n", "<br>") }
  end

  def image_item_content(item)
    content_tag(:a,
      href: relative_path(item.path),
      rel: 'maelstromify',
      title: item.label
    ) do
      tag(:img, src: relative_path(item.path))
    end
  end

  def audio_item_content(item)
    content = content_tag(:h2) { File.basename(item.path, ".*") }
    content << tag(:img, src: "images/sound.png", class: "audio-icon")
    content << content_tag(:audio, controls: "controls", preload: "auto") do
      tag(:source, src: relative_path(item.path))
    end
  end
end

# Build-specific configuration
configure :build do

  # Minify CSS on build
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Add gzip compression
  activate :gzip

end
