require 'set'
require 'pathname'
require 'nokogiri'

SITE_ROOT = File.expand_path('_site')
START = '/index.html'

# Normalize internal href to an existing HTML page under _site; return nil otherwise
def normalize_href(href, current_abs)
  return nil if href.nil?
  href = href.strip
  return nil if href.empty? || href.start_with?('mailto:', 'tel:', 'javascript:', '#', 'data:')
  return nil if href =~ /^https?:\/\//i
  href = href.split('#', 2).first
  href = href.split('?', 2).first
  return nil if href.nil? || href.empty?

  current_rel = current_abs.sub(SITE_ROOT, '')
  current_dir_rel = File.dirname(current_rel)

  target_rel = if href.start_with?('/')
    href
  else
    Pathname.new(File.join(current_dir_rel, href)).cleanpath.to_s.tap { |p| p.prepend('/') unless p.start_with?('/') }
  end

  # Directory index resolution
  if target_rel.end_with?('/')
    target_rel = File.join(target_rel, 'index.html')
  end

  # If no .html extension, try as directory index
  unless File.extname(target_rel).downcase == '.html'
    abs_dir = File.join(SITE_ROOT, target_rel)
    return nil unless Dir.exist?(abs_dir)
    target_rel = File.join(target_rel, 'index.html')
  end

  abs_target = File.expand_path(File.join(SITE_ROOT, target_rel.sub(%r{^/}, '')))
  return nil unless abs_target.start_with?(SITE_ROOT)
  return nil unless File.file?(abs_target)

  '/' + Pathname.new(abs_target).relative_path_from(Pathname.new(SITE_ROOT)).to_s
end

# Extract outgoing links, ignoring anchors inside elements with class 'floating-nav-item'
def outgoing_links(abs_path)
  html = File.read(abs_path)
  doc = Nokogiri::HTML(html)
  links = []
  doc.css('a[href]').each do |a|
    next if a.ancestors.any? { |anc| anc['class'].to_s.split.include?('floating-nav-item') }
    links << a['href']
  end
  links
rescue
  []
end

# Gather all html files
all_html = Dir.glob(File.join(SITE_ROOT, '**', '*.html')).map { |p| '/' + Pathname.new(p).relative_path_from(Pathname.new(SITE_ROOT)).to_s }

# BFS from START; only forward edges from discovered nodes
visited = Set.new
queue = [START]
adj = Hash.new { |h,k| h[k] = Set.new }

while (node = queue.shift)
  next if visited.include?(node)
  visited.add(node)
  abs = File.join(SITE_ROOT, node.sub(%r{^/}, ''))
  outgoing_links(abs).each do |href|
    norm = normalize_href(href, abs)
    next if norm.nil?
    adj[node].add(norm)
    queue << norm unless visited.include?(norm)
  end
end

orphans = all_html.reject { |p| visited.include?(p) }.sort

Dir.mkdir('analysis') unless Dir.exist?('analysis')
File.write('analysis/link-graph.txt', adj.keys.sort.map { |from|
  (["#{from} ->"] + adj[from].to_a.sort.map { |t| "  - #{t}" } + ['']).join("\n")
}.join)

File.open('analysis/link-graph.mmd', 'w') do |f|
  f.puts 'graph TD'
  adj.keys.sort.each do |from|
    adj[from].each do |to|
      f.puts "  \"#{from}\" --> \"#{to}\""
    end
  end
end

File.write('analysis/orphan-pages.txt', orphans.join("\n") + (orphans.empty? ? '' : "\n"))

puts "Reachable pages from #{START}: #{visited.size}"
puts "Total html pages: #{all_html.size}"
puts "Orphan pages: #{orphans.size}"
