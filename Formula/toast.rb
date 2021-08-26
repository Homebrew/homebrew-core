class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.42.1.tar.gz"
  sha256 "91a8a30b52fef41f94c0d2ee9a2af05dbfa68e9b83f5dc5ec8c2a4ddacb199fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5848cff38c67f9757086d16045b932729e5ed00ebc9a3692f1dc50f71bccaa07"
    sha256 cellar: :any_skip_relocation, big_sur:       "c42d88b41b0d23b3c77240f0dd377d820fe785d4df6b40a721d4dafc976683da"
    sha256 cellar: :any_skip_relocation, catalina:      "c4f7bb92c9349ba06ebbbb88220c56c1166e91bdd1e113d465e684c5b5117107"
    sha256 cellar: :any_skip_relocation, mojave:        "3558df41d8f3ef8370e381b0b0c8ef4779d03416e155d6eb105c1116f233a971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ece8ff87c943309466e33ffcd8ed00e90b7819c2c67cac84a3a22ac3422ad8e"
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
