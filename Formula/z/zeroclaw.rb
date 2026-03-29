class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "54d62c4dde87475f003b0404df1d343e86526df103eaf2045f961b1921871a77"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f8818349d40cf47ac01a527baf04f21591e66d8d216b834f04d07edbfcc8d5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27f7ec4a7171e45ba8243bae9ff6ba9a427a7da8dc67575058e3080ce5d731c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fbc5e56ab80fdac2db0b33fd716d16ddc3df7d2c89f3377518b9d0c43f0a8b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccd2aded3cd794a48d3c929e640fe184423829c1a32a8d7443bbba839c1d945a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10406434385abab14616c101158aa21e8a33bf6356d14a4779b34be4079cdfcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7423f02251870fe18edae66f8dd28c0d74f990a3c84d4c01f33d1a96edbdac8d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"zeroclaw", "daemon"]
    keep_alive true
    working_dir var/"zeroclaw"
    environment_variables ZEROCLAW_WORKSPACE: var/"zeroclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeroclaw --version")

    ENV["ZEROCLAW_WORKSPACE"] = testpath.to_s
    assert_match "ZeroClaw Status", shell_output("#{bin}/zeroclaw status")
    assert_path_exists testpath/"config.toml"
  end
end
