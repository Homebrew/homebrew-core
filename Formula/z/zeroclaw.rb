class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "1db6cd51af21e10128bb0804f945ae343ba5e03ee7458d28bfc40be2089cff54"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce797b78edbaf3c9d3add91063acce0423ce95398dea8757337f4b4f6224ad83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9112953ad241a6afaa8daab3d595d088c5504ead370ca430b002e743d9ac0f42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4ec6c1a9592c64bfb8695c3388d50efb8f9debb2ae9918a118c6768ad875460"
    sha256 cellar: :any_skip_relocation, sonoma:        "2507f62ea184159b8c67f2ecbd59a9e652c6aafa9054b4b8202b36bb0408f469"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bee709b05b8280924211b3bcebaad0959a9161da72d2b7f8baa036c3362b1a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57427e37a00fc96e70845efc835e1012a96f6602f737988439967e6820304bfe"
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
