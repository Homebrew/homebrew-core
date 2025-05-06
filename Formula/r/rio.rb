class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.2.14.tar.gz"
  sha256 "b0c9d72a08e4bbb8b3274f5ea6ee84936ab2f45025b14f4b790f5aa90d169c5f"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b03a31f36d5fb7c7891a4f30e84e28492fa9609db57ed97af189dffaccedd52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c121ff07432f78eecc058b78619bfb3949fdcc45b941061101cac2723b09fb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62e49ac1900e409a35fea4dbb411a059bdd4a32968c9f5a72555967acd7818da"
    sha256 cellar: :any_skip_relocation, sonoma:        "26823ab4a460c74a14a5793b33140e37aa492bd25422fd10a66448ba03f31271"
    sha256 cellar: :any_skip_relocation, ventura:       "91a11518ee947da821e65cfc8a63ec8234cb911d8cbceafa6b7db72d02dbd068"
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
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin/"rio", "-e", "touch", testpath/"testfile"
    assert_path_exists testpath/"testfile"
  end
end
