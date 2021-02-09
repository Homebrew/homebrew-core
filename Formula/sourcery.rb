class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.1.1.tar.gz"
  sha256 "19a2c397b34e59b0fd4a0aa2ee156f39a3367991bd6b36c2723530b3d7db974e"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d0c1efa15aca93ca30d7dd4dfdedd0e84a01b8d9ed6f79f922ecbfe6589f43d7"
    sha256 cellar: :any_skip_relocation, big_sur:       "b22bd470985f788c24fab43228f817e885afaadfc78013f49e075b586493c510"
    sha256 cellar: :any_skip_relocation, catalina:      "2aab02d91af910a422647647c6bbdea7d3b2f6ab5ef58d5ffbc7984465203cbf"
  end

  depends_on xcode: "12.0"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/sourcery"
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
