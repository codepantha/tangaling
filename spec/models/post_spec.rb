# == Schema Information
#
# Table name: posts
#
#  id            :bigint           not null, primary key
#  postable_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  postable_id   :bigint           not null
#  thread_id     :bigint
#  user_id       :bigint
#
# Indexes
#
#  index_posts_on_postable  (postable_type,postable_id)
#
# Foreign Keys
#
#  fk_rails_...  (thread_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Post, type: :model do
  describe '#save' do
    it 'belongs to a user' do
      user = create(:user)

      post = Post.new(postable: Status.new(text: 'Woohoo!'));

      post.save
      expect(post).not_to be_persisted

      post.user = user
      post.save
      expect(post).to be_persisted
    end
  end
end
