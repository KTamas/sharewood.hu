# == Schema Information
#
# Table name: feeds
#
#  id          :integer(4)      not null, primary key
#  feed_url_id :integer(4)
#  title       :string(255)
#  author      :string(255)
#  link        :string(255)
#  site_link   :string(255)
#  site_title  :string(255)
#  content     :text
#  published   :datetime
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Feed < ActiveRecord::Base
  belongs_to :feed_url
  validates_uniqueness_of :title, :scope => [:link]
  validates_presence_of :feed_url_id
  validates_numericality_of :feed_url_id
  
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
