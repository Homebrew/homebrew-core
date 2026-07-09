class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "a8531563365d69027a256d6e6c3b01668c5e2dd465278800821072eb8cc907c9"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19f1c2df49a121ed8ba26b9e431adfc72933ae3869ffd2a9adc739a681631b34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "627f45f3aee1498ea2cbedb70680ab4303c550a76f6f3f6ce71ec93dbe83fc95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad38f52d7224ecd441fff08e46fe2c6a477d0c719743748fbecf9a30e26ed804"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a4f1d8190f579dd33f9bbe30e534ced383318f255e38a833d759ded03a68aa1"
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
