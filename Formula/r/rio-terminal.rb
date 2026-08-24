class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.5.26.tar.gz"
  sha256 "ff07f37569855bc46be2ea36e0efd85467d662fa325395b0e5cc52b21a104c04"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d2391e2fcbe39a906b8b625faac76e5336d927298b8fa529849e7198a9c6550"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c8bade12d057bea5618010d3fd0537d0287b4d3753c004b68c61c070d489cfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3118ebc5cc746082eb503804125cb57bfee5b1e5772924bf78d953c22e5566dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6277a97422673072a8c7106c11391fa67be5cfeeb764f23f61527aa64dee94ca"
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
