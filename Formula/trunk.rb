class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.7.4.tar.gz"
  sha256 "cab41516583250624e12b0e78379935d60d5fc46cfa4aead8746d119ac615406"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33768319ca3c961d775c4a8b0119b6d7020d8e9a9a85ecf4633326cefcd79661" => :big_sur
    sha256 "fd38fca0e8a25bc74f366ad70a33d487705d108307f16491a1deddb3465e6c7b" => :arm64_big_sur
    sha256 "24b9add8333f05984d5d34e49f6631e24ea4dd3f01fd74aa929f0c3e0c078c36" => :catalina
    sha256 "a4e47e8f468442ead0174ed1e821cc1fc7cf95aba41970a43cdd6ec26db8cf72" => :mojave
    sha256 "53ffac0b8c5c5f4322d609ce50fbb37e7ce913e60bea3235d0d512bfc395aee1" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
