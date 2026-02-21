class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "7a8626db740df8aeec9be2dbac358e9acfb6812178be36736dd6a87e00296cad"
  license "MIT"
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6db9835aef789e139089449e8686216132c7633b0f7222dae8bd392b79171940"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "486f3566bb1cbd004443bb89060cead705ae5a8c9d4c671bbd9beab4519aaa35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "520491ae609b1242ff08e0a88b46c0f432ba159c32e4babdd171c1827cfcff60"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e2693c1cb6090bc680b7b785c260c10ad0cd77d3bc752387c9767cab275661f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "505944b58eb1c4acd55a26317f3a91b0ca4bd15f988833b930f8559c14c028fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f507a02012dff8d2f60659ed860b6a6cf1b21d3471762c2a027d7b85fe8dd194"
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
