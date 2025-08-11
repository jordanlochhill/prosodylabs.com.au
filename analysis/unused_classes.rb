require 'set'
require 'nokogiri'
require 'pathname'

SITE = File.expand_path('_site')
CSS_PATH = File.join(SITE, 'css', 'main.css')

abort('Build the site first: _site/css/main.css not found') unless File.file?(CSS_PATH)

# Collect class names defined in CSS
css = File.read(CSS_PATH)
# Grab .className tokens; skip .0 or numeric-only, and vendor pseudo elements
raw_classes = css.scan(/\.(?:[a-zA-Z_\-][a-zA-Z0-9_\-]*)/).map { |s| s[1..-1] }

# Remove duplicates and obvious non-class artifacts
css_classes = Set.new(raw_classes)
# Remove Tail end of combined selectors like .class:hover → already fine; we captured only before colon
# Filter some known false positives
css_classes.delete('0')

# Collect used class names from HTML
used = Set.new
Dir.glob(File.join(SITE, '**', '*.html')).each do |html_file|
  begin
    doc = Nokogiri::HTML(File.read(html_file))
    doc.css('*[class]').each do |node|
      node['class'].to_s.split(/\s+/).each do |cls|
        used.add(cls) unless cls.empty?
      end
    end
  rescue => e
    warn "Failed to parse #{html_file}: #{e}"
  end
end

unused = css_classes - used

# Write report
Dir.mkdir('analysis') unless Dir.exist?('analysis')
File.open('analysis/unused-classes.txt', 'w') do |f|
  f.puts "Total CSS classes: #{css_classes.size}"
  f.puts "Used classes: #{used.size}"
  f.puts "Unused classes: #{unused.size}"
  f.puts
  f.puts "Unused class names (from main.css):"
  unused.to_a.sort.each { |c| f.puts c }
end

puts "Wrote analysis/unused-classes.txt"
