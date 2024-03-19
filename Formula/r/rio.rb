class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.0.36.tar.gz"
  sha256 "0c179c16cee7874e1b5f3c56d63ad6949786650c45977a461aee0bcf9f748327"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39dac97d301a5d8f4c6971bc970575dda7ddbab86767820d236c6faa8640ed2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2f5c7708fb464eff607f8ef68a0c425e38c67deb19346979de089ebd767919b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcdf12211177a1048ed3727e03cc47cc99cda0af2deac5c15d83b72a29cdece4"
    sha256 cellar: :any_skip_relocation, sonoma:         "18adf265412f688c7eb974d72819b252bcfa9547f485971dac062b59f3889662"
    sha256 cellar: :any_skip_relocation, ventura:        "749e1d15643911a2582c0d4e6aaa16aaedadd7690dec9d63645bae0febd113d6"
    sha256 cellar: :any_skip_relocation, monterey:       "e90f297ee88a1325fd4ada85300767595116175f5b565e211d0d9f17115710be"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "frontends/cross-winit")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin/"rio", "-e", "touch", testpath/"testfile"
    assert_predicate testpath/"testfile", :exist?
  end
end
