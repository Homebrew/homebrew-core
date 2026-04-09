class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "f4bc82c8eb259feb34974e7ff2a817706cfa10030e8d08555f93912624c77bb7"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "235e2fdce970cbe7d226674a890e5b2b3e50da6c14e1dec88e712f9c4ca24367"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd9fa3e3e28c53475fe2dbb08fa64bc4a28069db63a3782b91a78f350a6bbbaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4511db38df384d42f2ed3539450f20ceeafef81e4d6b05261cb39ef63a1d7baa"
    sha256 cellar: :any_skip_relocation, sonoma:        "236ed43af2c57aab5109359893f2f8bf4a44e5a052467bc7e8daaf219c218db4"
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
