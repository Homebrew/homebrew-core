class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.0.37.tar.gz"
  sha256 "e78a4dceb1ba4f1c3b3d1fadd16f73861a3afb419607a04b27dd9a83dc95a238"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f4a4a65404891cfd2040cb4d5c7253e5d8e02852ad324576010c27d2762d9ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b2131c56c53adb1342022b913f4742215a6d0eb8eccc8a34bb951d48f23c546"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c08c74bd8221c8564794cda20e0f403051a50c1e2dea84af34765f1deddafaa4"
    sha256 cellar: :any_skip_relocation, sonoma:         "f71046253746820d4479d33cbde28ab703ddaabadda040ec690a9912a3b706a3"
    sha256 cellar: :any_skip_relocation, ventura:        "291421df1f702f2b32cb3cd1f3e07112c8deae07bc675649151fd423edd884ce"
    sha256 cellar: :any_skip_relocation, monterey:       "00c81c42207605e03210b097c76d213433eb019d2fd352a89edeffafc4d88d2a"
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
