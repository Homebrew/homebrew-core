class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.2.14.tar.gz"
  sha256 "db7e8c7dd32038d48b2f1f4a57f5a815f38c582abc6dff6a97c3ec9d71aa139a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23431265df5af3c28350f6e0068406cd409aca72acbf026b6a099d4000223601"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dff35b39fc1dd808ccd313e26e3a4a7a9a4d9b6fb4bc6fb5ef7f0d40e7fc950"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69e1df2d3bad7a23993dbe34da848ea95a53f7623007fa9aa9745df5fd2a0f0d"
    sha256 cellar: :any_skip_relocation, ventura:        "560b89ba11bc69bc3914aabc67c3b15535c3591a6efe43d4636ac9eb909dd98c"
    sha256 cellar: :any_skip_relocation, monterey:       "05270f74d71f23449271f9c6802c9ff4a055bd0a40ab86ca468af5a5b83c0b06"
    sha256 cellar: :any_skip_relocation, big_sur:        "111c69d06a1458c5e6a5c58b2d7e308e051fc99192ba8da6300b64444342547b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31b2d3804bf68efdd54c6e598d4f02fb15422c068310950b77fdee4ad0bdfddc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_predicate testpath/".xwin-cache/splat", :exist?
  end
end
