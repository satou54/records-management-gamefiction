require "rails_helper"

RSpec.describe Task, type: :model do
  describe "バリデーション" do
    subject { task.valid? }
    context "データが条件を満たすとき" do
      let(:user) { build(:user) }
      let(:task) { build(:task) }
      it "保存できる" do
        expect(subject).to eq true
      end
    end

    context "taskが空のとき" do
      let(:user) { build(:user) }
      let(:task) { build(:task, task: "") }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(task.errors.messages[:task]).to include "を入力してください"
      end
    end

    context "taskが31文字以上のとき" do
      let(:user) { build(:user) }
      let(:task) { build(:task, task: "a" * 31) }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(task.errors.messages[:task]).to include "は30文字以内で入力してください"
      end
    end

    context "goalが空のとき" do
      let(:user) { build(:user) }
      let(:task) { build(:task, goal: "") }
      it "エラーが発生する" do
        expect(subject).to eq false
        expect(task.errors.messages[:goal]).to include "を入力してください"
      end
    end

    #context "goalが文字のとき" do
    #  let(:user) { build(:user) }
    #  let(:task) { build(:task, goal: "10".to_s) }
    #  it "エラーが発生する" do
    #    expect(subject).to eq false
    #    expect(task.errors.messages[:goal]).to include ""
    #  end
    #end
  end
end
