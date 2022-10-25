class Taplo < Formula
  desc "TOML toolkit written in Rust"
  homepage "https://taplo.tamasfe.dev"
  url "https://github.com/tamasfe/taplo/archive/refs/tags/release-taplo-cli-0.7.2.tar.gz"
  sha256 "c4a7fc2adf44264523ed54d4dc3dd9eb6613f8495a7ca9b7a4c1cca662f1d41f"
  license "MIT"
  head "https://github.com/tamasfe/taplo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^release-taplo-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "492bdfd94f21f0e084baf915c028b67e22ca054ee7e95bce30c71bdba59b592d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "012c3e4a4bf5f282b853627c18b463a0db722dcb764ff8e72cb161a552275251"
    sha256 cellar: :any_skip_relocation, monterey:       "e49fe38d363d63ff754a0b6f6ddf17080caeea13142c24443ed7d92cb2c1cfb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf194672fae25371025b68ca88cc98836b4e366cf9680dc3b2f037b366c0ea45"
    sha256 cellar: :any_skip_relocation, catalina:       "14221b282be398f1138412e6f398b1c6d2b5c6715871a42d992f502bfb5b39da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f852fc463c95d38fd93b0ca973d7029bbb92fe968a5741f6f3059cce5713bea2"
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
