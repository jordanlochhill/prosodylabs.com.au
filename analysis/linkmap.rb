require 'set'
require 'cgi'
require 'pathname'

SITE_ROOT = File.expand_path('_site')
START = '/index.html'

# Return normalized absolute site path like "/foo/index.html" or nil if not an internal html page
def normalize_href(href, current_abs)
  return nil if href.nil? || href.strip.empty?
  href = href.strip
  return nil if href.start_with?('mailto:', 'tel:', 'javascript:', '#', 'data:')
  return nil if href =~ /^https?:\/\//i

  # strip query and fragment
  href = href.split('#', 2).first
  href = href.split('?', 2).first
  return nil if href.nil? || href.empty?

  current_rel = current_abs.sub(SITE_ROOT, '')
  current_dir_rel = File.dirname(current_rel)

  target_rel = if href.start_with?('/')
    href
  else
    # Resolve relative to current directory
    # Build a path like "/a/b/c" from current_dir_rel + href
    Pathname.new(File.join(current_dir_rel, href)).cleanpath.to_s.tap do |p|
      # ensure leading slash
      p.prepend('/') unless p.start_with?('/')
    end
  end

  # Map directories to index.html
  if target_rel.end_with?('/')
    target_rel = File.join(target_rel, 'index.html')
  end

  # If no extension, try as a directory index
  unless File.extname(target_rel).downcase == '.html'
    # if it points to a directory under site
    abs_dir = File.join(SITE_ROOT, target_rel)
    if Dir.exist?(abs_dir)
      target_rel = File.join(target_rel, 'index.html')
    else
      # Not an html page (asset or other file) → ignore
      return nil
    end
  end

  abs_target = File.expand_path(File.join(SITE_ROOT, target_rel.sub(%r{^/}, '')))
  return nil unless abs_target.start_with?(SITE_ROOT)
  return nil unless File.file?(abs_target)

  # Return normalized rel path with leading slash
  '/' + Pathname.new(abs_target).relative_path_from(Pathname.new(SITE_ROOT)).to_s
end

# Extract hrefs from an HTML file (best-effort regex)
HREF_REGEX = /<a\s+[^>]*href\s*=\s*"([^"]+)"/i

def outgoing_links(abs_path)
  html = File.read(abs_path)
  hrefs = html.scan(HREF_REGEX).flatten
  hrefs
rescue
  []
end

# Build graph via BFS
all_html = Dir.glob(File.join(SITE_ROOT, '**', '*.html')).map { |p| '/' + Pathname.new(p).relative_path_from(Pathname.new(SITE_ROOT)).to_s }
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
    unless visited.include?(norm)
      queue << norm
    end
  end
end

# Orphans = all html pages not reachable from START
orphans = all_html.reject { |p| visited.include?(p) }.sort

# Write adjacency list
File.open('analysis/link-graph.txt', 'w') do |f|
  adj.keys.sort.each do |from|
    targets = adj[from].to_a.sort
    f.puts("#{from} ->")
    targets.each { |t| f.puts("  - #{t}") }
    f.puts
  end
end

# Write Mermaid diagram (limited to top-level sections to keep it readable)
File.open('analysis/link-graph.mmd', 'w') do |f|
  f.puts "graph TD"
  adj.keys.sort.each do |from|
    adj[from].each do |to|
      f.puts "  \"#{from}\" --> \"#{to}\""
    end
  end
end

# Write orphans
File.open('analysis/orphan-pages.txt', 'w') do |f|
  orphans.each { |p| f.puts(p) }
end

# Console summary
puts "Reachable pages from #{START}: #{visited.size}"
puts "Total html pages: #{all_html.size}"
puts "Orphan pages: #{orphans.size}"
puts "\nSample edges:"
edge_count = 0
adj.keys.sort.first(10).each do |from|
  adj[from].to_a.sort.first(5).each do |to|
    puts "  #{from} -> #{to}"
    edge_count += 1
  end
end
puts "\nWrote: analysis/link-graph.txt, analysis/link-graph.mmd, analysis/orphan-pages.txt"
