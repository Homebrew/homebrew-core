class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.21.0.tar.gz"
  sha256 "717862ea7b61f444c68ddd0189f6940a3b74b978b9e3ad6edaa058ddc29d8643"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f71caa82403ad1f8b5602a0f3a9bb28ab2f4f4a2115a3447f9304437601e5b59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9828f7ad762f009af081799716a00d52c52d5f1142c0828672d758029706d9f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1158cd6d488f787a22ea86d925f09ff09cd98d8675f0de5a7187aa70519b5357"
    sha256 cellar: :any_skip_relocation, sonoma:        "4270bc11324881b71c417609a5982db5f09eabba568a380937127550d12a602a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceb1973a20b50738d353d17fd43d1b940767eb8effe05ef848160e9629c3ce41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1235e823b0105dee66193e56c33c89cfd8f2f7dc16994de9b021f7e4ec1c027"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_path_exists testpath/"todo.txt"
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
