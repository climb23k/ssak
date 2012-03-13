class PagesController < ApplicationController
  def home
    if user_signed_in?
      require 'fb_graph'
      # streamQuery = 'SELECT post_id, message, permalink, likes, actor_id, created_time FROM stream WHERE source_id'
      # streamQuery += '= 295421080475868 AND message != "" LIMIT 1000 OFFSET 0'
      string = ''
      # response = open('https://graph.facebook.com/1061856745/feed?access_token='+session['fb_at'] )
      array = FbGraph::Query.new(
        'SELECT url FROM link WHERE owner = 1061856745'
      ).fetch(session['fb_at'])
      
      num = 0      
      # each stmt
      array.each do |link|
        the_link = link[:url]
        if the_link.length>0 && the_link.include?('youtube')
          trimmed_link = the_link[(31)..-1]
          code = ''
          trimmed_link.each_char {|char|
            break if char == '&'
            code += char.to_s
          }
          string += '<p>code: '+code+' -- link:<a href="'+the_link+'">'+the_link+'</a> </p>'
          # string += '<p>from: '+link[:owner]+'</p>'
          string += '<iframe src="http://www.youtube.com/embed/'+code+'" frameborder="0" allowfullscreen></iframe>'
        end 
      end

      render :text => '<html><body>'+string+'</body></html>'
    end
  end
  def about    
  end
end