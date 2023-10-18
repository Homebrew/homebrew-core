class Taplo < Formula
  desc "TOML toolkit written in Rust"
  homepage "https://taplo.tamasfe.dev"
  url "https://github.com/tamasfe/taplo/archive/refs/tags/release-taplo-cli-0.8.1.tar.gz"
  sha256 "8c011d724bb6dd5d6af1fc4d416409f6686102850a6e74779f6bfa785c03bf4f"
  license "MIT"
  head "https://github.com/tamasfe/taplo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^release-taplo-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1355cd35a224866393615a6f1a8123d92ceb285a015251e9a2f5634509fbd8b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e86ebcbf57d211c2b41d4e1d3e3e0e4161100bec8ad5ab34d72413f6f0c7ce1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9882664487f5baa3291ff22860c74cafa55a1d8a69d7f0dbcfbd192f1d69a21e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d12a592e34822070383413cec3f686b7b6c6bc7b9d6c86b756543905cd6c147"
    sha256 cellar: :any_skip_relocation, sonoma:         "59415f3727cf9367f859bb168098552012510d831fcffa0b43b77b80c88c138a"
    sha256 cellar: :any_skip_relocation, ventura:        "1bd275dfe3700412f6cdfc2c7108859d496876f4d1a239462872896d1dab6840"
    sha256 cellar: :any_skip_relocation, monterey:       "307961e6683b9671306f2210c319d597c9cc038c0201f13ec48774934694b92a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e65757c53796efd8dfef3b40e177eadec82b77a6f5365a89ecdf279046910656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f819a66210b918749ce6f91b3ab08496e6e69f3c1cd323452b7288d7c8226f08"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "lsp", *std_cargo_args(path: "crates/taplo-cli")
  end

  test do
    (testpath/"invalid.toml").write <<~EOS
      # INVALID TOML DOC
      fruit = []

      [[fruit]] # Not allowed
    EOS

    assert_match("invalid file error", shell_output("#{bin}/taplo lint invalid.toml 2>&1", 1))
  end
end
