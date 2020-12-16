require 'rails_helper'

RSpec.describe 'ツイート投稿', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @tweet_text = Faker::Lorem.sentence
    @tweet_image = Faker::Lorem.sentence
  end
  context 'ツイート投稿ができるとき'do
    it 'ログインしたユーザーは新規投稿できる' do
      # ログインする
      visit new_user_session_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      # 新規投稿ページへのリンクがある
      expect(page).to have_content('投稿する')
      # 投稿ページに移動する
      visit new_tweet_path
      # フォームに情報を入力する
      fill_in 'image', with: @tweet_image
      fill_in 'text', with: @tweet_text
      # 送信するとTweetモデルのカウントが1上がる
      expect{
        find('input[name="commit"]').click
      }.to change { Tweet.count }.by(1)
      # 投稿完了ページに遷移する
      expect(current_path).to eq tweets_path
      # 「投稿が完了しました」の文字がある
      expect(page).to have_content('投稿が完了しました。')
      # トップページに遷移する
      visit root_path
      # トップページには先ほど投稿した内容のツイートが存在する（画像）
      expect(page).to have_selector ".content_post[style='background-image: url(#{@tweet_image});']"
      # トップページには先ほど投稿した内容のツイートが存在する（テキスト）
      expect(page).to have_content(@tweet_text)
    end
  end
end
