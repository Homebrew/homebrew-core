class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "2372e084a3245cdc5d33ca4862668be278e0ee0b25a1481ced94df803c1db669"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2e744ab0ae37a082284d6d1ec67a38c325944c0cdc5d8d14542ff3af1c90268"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5b057f58ddf918597a532d9dd43dc44b1f3662a8214f5454818c76a07ba29dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e28c275803c2e8b00b8e8bbd2295e41006753d270451f9af084e242ba86fbf5"
    sha256 cellar: :any_skip_relocation, ventura:        "0a554e82a0bd43e71119423d72f9676888a0061e696e966f7135b20cc2b4ba16"
    sha256 cellar: :any_skip_relocation, monterey:       "71075b21ab661ab7073e7a0378876d2ba2d89bd656d3ebfa64006a7215a94d55"
    sha256 cellar: :any_skip_relocation, big_sur:        "f81944414501f5de8b4f6a7d3df8513155500dbcdcfbf767ca99bf685fadee3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfa2f9172bcbbe449aa454f2b42947c50a221cd02cc0c5addb179efd8d7d3b0a"
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
