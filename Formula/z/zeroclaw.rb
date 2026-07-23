class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://www.zeroclawlabs.ai/"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "9dd537164012bd122cdc4837b09a20146ea3311aa493cd642a870778871f0d27"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1298729feddca109334ab079e38c11f5907d706c9d1060778da6bb49681f2eb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bb4b5a590f7a250207d15b97c4b33ceaad79097f41f3c3df7e2ba9391ea6631"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c066be1f46ef47c939de53e10070dcc7948e58e450c270fa30c727afaa976fee"
    sha256 cellar: :any_skip_relocation, sonoma:        "802fe3d43438e6efe6cb77c15891f4a85f2f1196acafada0d022727bc346b526"
    sha256 cellar: :any,                 arm64_linux:   "c83652f517c3e832458157c9a2492ed10984029211e4b504e995564aff3395fa"
    sha256 cellar: :any,                 x86_64_linux:  "93c426e4f56828ef4394d6f5f2004cb935c0935525ac9acec11cb47b09e1ec83"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "install", *std_cargo_args(path: "apps/zerocode")
  end

  service do
    run [opt_bin/"zeroclaw", "daemon"]
    keep_alive true
    working_dir var/"zeroclaw"
    environment_variables ZEROCLAW_WORKSPACE: var/"zeroclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeroclaw --version")
    assert_match version.to_s, shell_output("#{bin}/zerocode --version")

    ENV["ZEROCLAW_WORKSPACE"] = testpath.to_s
    assert_match "ZeroClaw Status", shell_output("#{bin}/zeroclaw status")
    assert_path_exists testpath/"config.toml"
  end
end
