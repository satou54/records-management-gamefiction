require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    subject { user.valid? }
    context "データが条件を満たすとき" do
      let(:user) { build(:user) }
      it "保存できる" do
        expect(subject).to eq true
      end
    end

    context "nameが空のとき" do
      let(:user) { build(:user, name: "") }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(user.errors.messages[:name]).to include "を入力してください"
      end
    end

    context "nameが26文字以上のとき" do
      let(:user) { build(:user, name: "a" * 26) }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(user.errors.messages[:name]).to include "は25文字以内で入力してください"
      end
    end

    context "emailが空のとき" do
      let(:user) { build(:user, email: "") }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(user.errors.messages[:email]).to include "を入力してください"
      end
    end

    context "emailが256文字以上のとき" do
      let(:user) { build(:user, email: "a" * 256) }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(user.errors.messages[:email]).to include "は255文字以内で入力してください"
      end
    end

    context "emailがアルファベット・英数字のみのとき" do
      let(:user) { build(:user, email: Faker::Lorem.characters(number: 16)) }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(user.errors.messages[:email]).to include "は有効ではありません", "は不正な値です"
      end
    end

    context "パスワードが空のとき" do
      let(:user) { build(:user, password: "") }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(user.errors.messages[:password]).to include "を入力してください"
      end
    end

    context "パスワードが5文字以下のとき" do
      let(:user) { build(:user, password: "12345") }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(user.errors.messages[:password]).to include "は6文字以上で入力してください"
      end
    end

    context "パスワード(確認)が空のとき" do
      let(:user) { build(:user, password_confirmation: "") }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(user.errors.messages[:password_confirmation]).to include "を入力してください"
      end
    end

    context "パスワード(確認)がパスワードと一致しないとき" do
      let(:user) { build(:user, password_confirmation: "123456") }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(user.errors.messages[:password_confirmation]).to include "とパスワードの入力が一致しません"
      end
    end
  end
end
