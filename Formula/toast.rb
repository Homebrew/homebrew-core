class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.45.0.tar.gz"
  sha256 "686d049605760964d8daf671f557852c87a11f5d2ce25e4e5c17e71b3a1130a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cdf36f9b8abeef738ed3a584bb50fc33897ddaacf302cf6682551d70c9a1b11b"
    sha256 cellar: :any_skip_relocation, big_sur:       "74a870261664364240618f3e446cd40cb677d91d5ac820b77a27d77ec51fda39"
    sha256 cellar: :any_skip_relocation, catalina:      "42b22b5eb4f6558430bd7d52992d6cfc24d67bfdd81438c06ddf6f8ebd2d7036"
    sha256 cellar: :any_skip_relocation, mojave:        "39515aa2829698a5534efc9b146b5a38fef405569daae5668a3e2ebd7598541e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cda3b07a243113f1286751dadfdc23c7fd99e86528cdbb3ca5d381ffa94cd7d4"
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
          description: brewtest
          command: echo hello
    EOS

    assert_match "homebrew_test", shell_output("#{bin}/toast --list")
  end
end
