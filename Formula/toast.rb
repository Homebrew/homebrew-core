class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.39.0.tar.gz"
  sha256 "0794eaa10790e15d82d72f9f763be2a1a47097b5dd785c025b1846615bbaec73"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "071881be259aebbed274db8e19ffb4366a7f6899c10adae7765c469ac78f5d73"
    sha256 cellar: :any_skip_relocation, big_sur:       "24def83bb5382fea9a4fb899dec6621bcd2c335f4ee4ff7339551ea23a9414b9"
    sha256 cellar: :any_skip_relocation, catalina:      "c4b5de1b59d1e44bc17dbf3010abda403b6353d61e9fe726a3534c10ee5a9025"
    sha256 cellar: :any_skip_relocation, mojave:        "858dbd7fe0e101d22bb06431ab8e93bf76a39e4676f6b70293c9387170120553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d8165efbbf2fbece51b41ccdf104e3a5ca00590879ec7b814f3942a716f8791"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"toast.yml").write <<~EOS
      image: alpine
      tasks:
        homebrew_test:
          command: echo hello
    EOS

    assert_match "homebrew_test", shell_output("#{bin}/toast --list")
  end
end
