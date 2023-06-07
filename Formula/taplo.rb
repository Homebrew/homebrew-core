class Taplo < Formula
  desc "TOML toolkit written in Rust"
  homepage "https://taplo.tamasfe.dev"
  url "https://github.com/tamasfe/taplo/archive/refs/tags/release-taplo-cli-0.8.0.tar.gz"
  sha256 "8383920ba8bf90b98cf47628df4bf998ee224965af449d3f11f0e199ce43fa0a"
  license "MIT"
  head "https://github.com/tamasfe/taplo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^release-taplo-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5647a9506b7ef922984d37cf9a49c4c66f62ac924726e3e81b2b556689ce66fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d248d001232b0a4d5e3ca78551fc702aabe96bc3ee3ff183e17ca79a326b220"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc69d10c27832bdf8d6a55c4f14d5e2245b2aaa486a7088183785bc697e69a06"
    sha256 cellar: :any_skip_relocation, ventura:        "2b79ec3bb4aa2af6fa89cd364a41bbf3f4e759013af1abd499e970887e5e7e60"
    sha256 cellar: :any_skip_relocation, monterey:       "6edf00e22f6cbe57001b35b264ca2f52f1417059bd602214304ad8b5b23c6bee"
    sha256 cellar: :any_skip_relocation, big_sur:        "26dc1b656b22cf0e31ed1bd28b6d52d8a59c2730f53124e4d90cb52c5e7b5807"
    sha256 cellar: :any_skip_relocation, catalina:       "bbdf96677f9c4187e2e42329eac5a8c883779107c42ea8c7f4fc1c53f4cee814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41bf74ca5ef3592354ac66469f85e1b1e5a9a0c56be584b781e7e3214d27c482"
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
