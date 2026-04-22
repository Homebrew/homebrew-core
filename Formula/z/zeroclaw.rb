class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "22d13d5d3820df13babed877e8f30b8cae959ba9c8554fdf1875c9a733932298"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a1b964d714e271070b046fd90b37d0da01aba5cf1296dd28f4ef15e2d30615f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b88fdff6635dfcba8ac6154f0d7be6053bff1cb2c737e0f5752c02b627e7fe52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "655426bc1f3157050487081e2bbc2be2f82411031076b67ebd85295b92c688cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d352365215bb106dbdb70daace179e5c7fd5ec2986b6c94ec6f2f0db95d9b984"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc6669f004fb4808230ec6e654fd4f4ca530672662a26184c0004fcca7961f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "723c8548b6b7bcf5d1a73bf813ad1f579d4c083a16868937b6c5cc35b81e7f3c"
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
