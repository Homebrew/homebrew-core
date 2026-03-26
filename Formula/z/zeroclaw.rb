class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "482725398ebe138f0aaef2ac80a058425c754cb1fe3d92bb2d690ada9cde1319"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd5a4702bc50c2af4343c430cee1480bf288e9d647d7045d9b1598dacd8c9f06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfb95ba9e8f3ec179ab1c57aefd72dc213ccf59f239cdf03303644b58b304a62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c25e64aa39f603fd82c4d3425879077691ecb680b8747162f38769a485711d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "be88952c9d75cc17c03b7d7aab7bbced6894de49b1f76fe1ed846ab10f52fc12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7adf5f8b2831ec9327b5a8567fb29c8853c4b30f718060e045ac7a53728426b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63a02f5a289e01ba68687a00358db41d1343d3fb76284636f6e6354a9a6fcdf9"
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
