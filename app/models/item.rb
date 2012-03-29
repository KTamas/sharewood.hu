class Item < ActiveRecord::Base
  belongs_to :feed
  validates_uniqueness_of :title, :scope => [:link]
  validates_presence_of :feed_id
  validates_numericality_of :feed_id
  
  def clean_content
    sanitize_options = { 
      :elements => %w[a abbr b blockquote br div cite code em i li ol p pre param s small strike strong sub sup u ul var object iframe embed img], 
      :attributes => {
      'a' => ['href'], 
      'img' => ['src', 'width', 'height', 'alt'], 
      'iframe' => ['src', 'allowfullscreen', 'frameborder', 'height', 'width'], 
      'embed' => ['src', 'height', 'width', 'allowscriptaccess', 'allowfullscreen', 'flashvars'],
      'object' => ['width', 'height', 'classid', 'codebase', 'movie', 'data', 'type'],
      'param' => ['name', 'value', 'valuetype', 'type'] }
    }
    return TidyFFI::Tidy.clean(Sanitize.clean(self.content, sanitize_options).force_encoding('utf-8'), :show_body_only => 1, :char_encoding => 'utf8').force_encoding('utf-8')
  end
end
