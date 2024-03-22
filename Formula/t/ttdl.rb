class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "0c37d55e2d0c6629e78e130dd5543fc6660ccfa5623a8d6ccba1311707664b57"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e6c05173a6100ea0ab9712d89e7997b49d93b423c7afcb476438a8a0a5106d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8182ab95a65a975701a818972fe56194299c5ab7c638ff755c66aca81e521889"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ce89b1d55d1d5b4584cc8f95238d2790bf4d869df51779f3508a0bc3a8c9eb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "64a1a075169c6e30d654f4a396413ed53fb33a67b5f986b4158f4f5b2df60e7b"
    sha256 cellar: :any_skip_relocation, ventura:        "6094cff60d6796a3dfc5f1ba1cbcf4b583f8e0cec868d1a120fb2899633af80d"
    sha256 cellar: :any_skip_relocation, monterey:       "8ac5080aabf3c5acecbe780fd254acccef8264fb881006260cc8b80808b5ba48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac5d6517afe86ec441830dfdc043d4a9c4b185600ae8500fad70d4b2e749a756"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_predicate testpath/"todo.txt", :exist?
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
