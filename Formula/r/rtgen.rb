class Rtgen < Formula
  desc "Interactive generator for Tauri v2 projects with ready-to-use Dev Containers"
  homepage "https://github.com/patrickfp93/rtgen-cli"
  url "https://github.com/patrickfp93/rtgen-cli/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "90d450fd08a0b95118a7930cd55314019c9031d33df7df3ec30096ac2a6d7217"
  license "MIT"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rtgen templates")
    assert_match "lite", output
    assert_match "gpu-cuda", output
  end
end
