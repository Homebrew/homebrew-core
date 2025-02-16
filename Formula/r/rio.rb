class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "97376694c864785bd7e6214d8d5d26dda47e9a7d134beeaa4dcf75bbebc63362"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "641b29b493f88844f01cb3088c7011a1dc1a0415f2f6c39932008ebd72586a9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6d3434f333413d2114b56f1c2c776e78302c8abbf1a7b72343062de9f172651"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a66f657a0f7d9357af2f8ce8d7a3d21e42e29b65428864fa3b706fc65476e5e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "eda24f6598302031cb431870243ebbeffdb13af2b52d3fba67e5a4ce1a079646"
    sha256 cellar: :any_skip_relocation, ventura:       "932da472a6900fd5f969d35764f395d33d42b19f1d27271eaeef1951bd8fd769"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

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
