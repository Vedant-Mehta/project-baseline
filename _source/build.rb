#!/opt/local/bin/ruby -w

# default behavior = do_all
do_html = false
do_css = false
do_js = false
do_git = false
do_all = true

# if a single behavior is selected, cancel the do_all
ARGV.each do |a|
  if a == "html"
    do_html = true
    do_all = false
  end
  if a == "css"
    do_css = true
    do_all = false
  end
  if a == "js"
    do_js = true
    do_all = false
  end
  if a == "git"
    do_git = true
    do_all = false
  end
end

# process haml files into html
def html
  haml_opts = '-f xhtml'
  # process partials
  puts 'Compiling Partials...'
  inc_files = Dir['./haml/_partials/*.haml']
  inc_files.each do |name|
    file_input = name
    file_output = name.sub('.haml','.inc')
    haml_call = 'haml '+haml_opts+' '+file_input+' '+file_output
    `#{haml_call}`
    puts ' :: Converting '+name+' => '+file_output
  end
  puts 'Partials compile complete...'
  # process pages
  puts 'Compiling HTML files...'
  haml_files = Dir['./haml/*.haml']
  haml_files.each do |name|
    file_input = name
    file_output = name.sub('.haml','.html').sub('./haml/','../www/')
    haml_call = 'haml '+haml_opts+' '+file_input+' '+file_output
    `#{haml_call}`
    puts ' :: Converting '+name+' => '+file_output
  end
  puts 'HTML compile complete...'
  # regex/cleanup script
  puts 'Calling HAML cleanup script...'
  `./_scripts/hamlcleanup.pl haml/_partials/*.inc`
  `./_scripts/hamlcleanup.pl ../www/*.html`
  # move files as needed
end

# compile and compress CSS files
def css
  puts 'Compiling LESS files to CSS...'
  `lessc ./less/main.less ../www/_res/css/uncompressed/main.css`
  puts 'Compressing CSS files...'
  `java -jar ~/scripts/yuicompressor-2.4.2.jar ../www/_res/css/uncompressed/main.css -o ../www/_res/css/main.css`
end

#compile and compress JS files
def js
  puts 'Compressing JS files...'
  `java -jar ~/scripts/yuicompressor-2.4.2.jar ../www/_res/js/uncompressed/main.js -o ../www/_res/js/main.js`
  # --nomunge
end

# do local Git commit
def git
  require 'parsedate'
  puts 'Doing local Git commit...'
  d = Time.new()
  git_comment = "#{d}"
  `git add ../.`
  `git commit ../. -m "#{git_comment}"`
end

puts '** Starting Build Process **'
if do_html
  html()
end
if do_css
  css()
end
if do_js
  js()
end
if do_git
  git()
end
if do_all
  html()
  css()
  js()
  git()
end

puts '** Build Complete! **'