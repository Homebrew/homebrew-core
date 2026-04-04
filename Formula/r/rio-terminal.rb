class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "228be60f63e4c55cb4270ab177a3d73aef03f91d75ae3d1efe6b62bc0887377a"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0f0e1318a608ec1f04f749f05546993474a2f6ff02ee9b775cbabc95e5eaea4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e88965e20aaaa671770a06b935451102cba7da952697a4c830af03cf186eafcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "495e88efe54141f9d252f27efbeb72f1f75aef463d09c422b0447abfbc9737e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "368e45004d569d2bf83526335419f13b6d98fb294bf4e7f8a0fbc03192175c7f"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  conflicts_with "rasterio", because: "both install `rio` binaries"
  conflicts_with cask: "rio", because: "both install `rio` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "frontends/rioterm")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")

    system bin/"rio", "--write-config", testpath/"rio.toml"
    assert_match "enable-log-file = false", (testpath/"rio.toml").read
  end
end
