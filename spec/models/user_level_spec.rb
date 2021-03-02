require 'rails_helper'

RSpec.describe UserLevel, type: :model do
  describe "バリデーション" do
    subject { user_level.valid? }
    context "データが条件を満たすとき" do
      let(:user) { build(:user) }
      let(:user_level) { build(:user_level) }
      it "保存できる" do
        expect(subject).to eq true
      end
    end
    context "levelが空のとき" do
      let(:user) { build(:user) }
      let(:user_level) { build(:user_level, level: "") }
      it "エラーが発生する" do
        expect(subject).to eq false
      end
    end
    context "total_experience_pointが空のとき" do
      let(:user) { build(:user) }
      let(:user_level) { build(:user_level, total_experience_point: "") }
      it "エラーが発生する" do
        expect(subject).to eq false
      end
    end
  end
end
