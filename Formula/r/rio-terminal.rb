class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.5.25.tar.gz"
  sha256 "4e6c3c412e8db1e8d7db3bb043a39afc2fd78091ab30ce4c6d264f96c25a5d60"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e009923e5eb00bdbac553db1537c52164cbc01462534cd5004b9b5e786a1b77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "282a3f54d3c1149adb77804870a87b57487da8e703055e96c12a4d8134369b0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18fc5a8bfd80d8a6f0c6d42bfdd122433564a934b4bfccbb9d53c60279fe69e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb41e947b2bc3a0c0f07aa40bbbc627011b6defbd4efcc31e945f802f5692988"
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
    assert_path_exists testpath/"rio.toml"
  end
end
