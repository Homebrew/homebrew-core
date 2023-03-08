class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.46.2.tar.gz"
  sha256 "e094964e798b86aedd8a2ddeed1ff52e8166a455b231aec8ac82b2123ad5c0ab"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32674ee551f4208527a7988b98480c9e74726564a64c83159b673d256d57f517"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faf49e864fafd7d77a105ee3fdc39195cb8262e445e8d6d1fec927dd7bf99839"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81ecd5e17a90923d14a91f2c26a29bcce43f4c8beecd5364d2e86747f4f29833"
    sha256 cellar: :any_skip_relocation, ventura:        "7e181fcf3dd6cf7fbb60595ac49c891e97fcb468a2ee0aafef3db05fc575f9fa"
    sha256 cellar: :any_skip_relocation, monterey:       "0fe3c2c44a3f8d78d803ea2a57c05de77da1077923ae42a9e236cccc3d11f848"
    sha256 cellar: :any_skip_relocation, big_sur:        "09df99a4ba3c28d8174a1608c76d9f6982f68c4530866c762b40cbc0f4e8e4c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27b7c03f2c2d1d2b38b2a7fd1355d9b409683f4a5c88a5bbe28d9b783f08d126"
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
