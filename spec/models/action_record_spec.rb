require 'rails_helper'

RSpec.describe ActionRecord, type: :model do
  describe "バリデーション" do
    subject { action_record.valid? }
    context "データが条件を満たすとき" do
      let(:user) { build(:user) }
      let(:action_record) { build(:action_record) }
      it "保存できる" do
        expect(subject).to eq true
      end
    end
    context "action_dayが空のとき" do
      let(:user) { build(:user) }
      let(:action_record) { build(:action_record, action_day: "") }
      it "エラーが発生する" do
        expect(subject).to eq false
      end
    end
    context "actionが空のとき" do
      let(:user) { build(:user) }
      let(:action_record) { build(:action_record, action: "") }
      it "エラーが発生する" do
        expect(subject).to eq false
      end
    end
    context "経験値が空のとき" do
      let(:user) { build(:user) }
      let(:action_record) { build(:action_record, action_experience_point: "") }
      it "エラーが発生する" do
        expect(subject).to eq false
      end
    end
  end
end
