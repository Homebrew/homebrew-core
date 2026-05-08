class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "28bedc7022f1862a12ea2b97949fb06f62d9763ed6885d08802ff1113fcdc5e8"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "423ea43bc65bb9d9fbc265d34369ca0789c41b22adbadece871f91237bd8a3eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ded374d654b0d42ecb65f9f52d220eec9fe56ee3482e0ba92ec4dfc270448a0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77a5166a0d8ef6d4bff38450e64492cc1773d90c95ea1911334532d02c044caa"
    sha256 cellar: :any_skip_relocation, sonoma:        "d170785f008e1b3deff532e1ed623016672af453824135d0fd8d566d685eee7e"
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
