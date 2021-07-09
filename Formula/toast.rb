class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.38.0.tar.gz"
  sha256 "61272e74c40493d793b77159689b9dad32c9040ceca62b1d118189d3f7ac1858"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "731c05efe262d9bb46c951a9aaad10288bfc4d61c7387834ed8ac1379f966f2a"
    sha256 cellar: :any_skip_relocation, big_sur:       "f5474253963b95a4a6b4d1e7f59cab369cce83aa261d41c969753e17f598b46c"
    sha256 cellar: :any_skip_relocation, catalina:      "1be132097522b56ba715bb4fce8a34c4602a0be324266c8ffeb5c66f74b1ed8f"
    sha256 cellar: :any_skip_relocation, mojave:        "fb1ae196bfef5e59e4a659d0a2697791c3ca0d75c7ccd07e53895ce750a9535c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0feb7190772cddb5abe7cadfcec04077bec8d96ed9ce83ad44be48d190327f0"
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
