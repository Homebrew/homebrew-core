class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.2.20.tar.gz"
  sha256 "10c70fe13c4261593359fcf9ec489770cb056d07153d790193bfa8621ac4ca42"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63e09e743db4330037115be47c3a07574f783f3879e7f0ceda64b228ea26334a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa14fdda5addcc287151a57650214e38be7ab91a2d0ba81f3c4d16bfb1ae2981"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "072d52ac1161c68b075aff880a50733aa9e9c05d30c9ba20984912e1efdf9e2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "86b53b046508dcd7a6e4ada2c3399e413f7a716053cb26d4bd1b49996368c7d5"
    sha256 cellar: :any_skip_relocation, ventura:       "0407e0ab3bc337af5587784cbec9f49c5da133377a9e15323aeb9e7d28edd2e6"
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
