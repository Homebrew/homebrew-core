class Taplo < Formula
  desc "TOML toolkit written in Rust"
  homepage "https://taplo.tamasfe.dev"
  url "https://github.com/tamasfe/taplo/archive/refs/tags/release-taplo-cli-0.7.0.tar.gz"
  sha256 "6b6d06220dabc3a63e17b87ca4be1b9dfde97dc3c6bd6e8115cc5d2e2dad9bbe"
  license "MIT"
  head "https://github.com/tamasfe/taplo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^release-taplo-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77dc396f2ee94895dbbc440810530018307acf6dd645d63e6f6f6b39c2a7f7f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20bedf8ec362a6c9830225aa9335636afb3021ed61431ad544cfa177138ad9b9"
    sha256 cellar: :any_skip_relocation, monterey:       "ea7f4b0274fa1e9720a7c85fe7008b64748312d42571c1f4db1c6525c8bb6b06"
    sha256 cellar: :any_skip_relocation, big_sur:        "85aa81d4d3f171f68e6354086601c5efe1d3c43f00516d65c23a363d7fc883f3"
    sha256 cellar: :any_skip_relocation, catalina:       "04969974fab6293be7cf97f54eeda0c3c15cbdd29e14622e63814426e9d89b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "192494a3b00fbd904fe2c82cac082bba6273715395a11ee3cf6f115d36b05462"
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

    assert_match("invalid TOML", shell_output("#{bin}/taplo lint invalid.toml 2>&1", 1))
  end
end
