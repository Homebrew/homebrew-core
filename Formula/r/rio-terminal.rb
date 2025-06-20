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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fe8c0988a0c7e051c3178bff4d14961e5e48974d3788f93c81421ac0304a450"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57edf06bbc52212b16502d6fc1657ca2347acdad243dbcea02e7c6517fa572d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66f8c4f77323528c013148f7d83d824cb5fe38f9cebc982299631912e379905c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b1f3d4f56e0fa28d4796e3b69d05b93a546c34eefbf472c3ef316859f9df91e"
    sha256 cellar: :any_skip_relocation, ventura:       "2ef2301553d2cd8f7df6ec7e13c3dbe64bf5be6c32407eeae98f860ae27af8c2"
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
