class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "502ef9a8c61e8aa29d4b386fdab951a6d2d287a071bd87475921b08029905553"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3219f2f64371e4042b1167155167b613c382ec861f9a55537aa92b4a42a2f4ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10bd7a2552555266abb24c03e72f879e26adcc2329e807bf0e3323bd5aa34529"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "248e1b297e9c599b521e1d6d2aec257dda2ffdc0d9a35854652ea1141f077111"
    sha256 cellar: :any_skip_relocation, ventura:        "2bbb2a71c981beb04b9058421ed3aae27088ea7fd5ba6eb7aba7736cccf508e1"
    sha256 cellar: :any_skip_relocation, monterey:       "6c55be4bfe5a4dbe7d450e7708e8cbe7f5b6f3cdb2cd184a70f305ffced9aae0"
    sha256 cellar: :any_skip_relocation, big_sur:        "292c4e04e7954a8de94215ab05b859d9d005e9960c579aa7cd1c763fed245996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e982a0ef783a414af9838244fc05b8f9ebfde9e2afb0533e7a8b7dfae36c6a44"
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
