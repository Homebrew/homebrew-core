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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45a0a7c6515d34157b0e618a0ea8aa3d4df96a3a8f56e2e671ebcda4f783db78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea03e4c35132b794efa36fa109042e19d05aaa15e5526570d59eabd589f5f076"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e46c5643b77247850d922b794c9b75fc0cfb321d63d21fefcb42c7787f146fb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c8eabdd65db6f9c60bc19d0c7c79b065f6b5b132ab232b24b92f405dafd587c"
    sha256 cellar: :any_skip_relocation, ventura:        "fdd119942655526b14e7a2a4cade28049c36f3f908ec0ba5da86c142201d5bf7"
    sha256 cellar: :any_skip_relocation, monterey:       "a966447a6fffec562ae5c7354ba767d7c93432fea007f08d9aac85856a089251"
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
