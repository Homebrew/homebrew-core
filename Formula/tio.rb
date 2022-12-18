class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v2.5/tio-2.5.tar.xz"
  sha256 "063952ee90a78cee180f6e660d6c73773dfc109efcdc151585accfe1500c44a7"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dd89b3e200c51927c1ba619d5707105fefecad2d2ca25d758050cd97b315e6de"
    sha256 cellar: :any,                 arm64_monterey: "3af3b33c9cab2f14e237298ab242c33c2dd0d3c499767f0fb19e51dece9aee30"
    sha256 cellar: :any,                 arm64_big_sur:  "6d2da82e3070c7210b465f3a62ba8c0f1615cc2b4fcfb57b741ce4120bcae5eb"
    sha256 cellar: :any,                 ventura:        "80f6f0d39cfb712d055bb1a17fd74d34f5d359e7818ed53365495881019f9711"
    sha256 cellar: :any,                 monterey:       "16550a044ec987d6e121b6206fa2dcb24a6b0669394dc58836d2c1f9b65dedfc"
    sha256 cellar: :any,                 big_sur:        "f0415808fde5b207d212b678cfa40c1f2b1de1074e078acb0808c8f5ef2616bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7385f55b676205f42e1bf3ccab48ab73a54e2ddad41716ca82b703d222b214fe"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "inih"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    # Test that tio emits the correct error output when run with an argument that is not a tty.
    # Use `script` to run tio with its stdio attached to a PTY, otherwise it will complain about that instead.
    expected = "Error: Not a tty device"
    output = if OS.mac?
      shell_output("script -q /dev/null #{bin}/tio /dev/null", 1).strip
    else
      shell_output("script -q /dev/null -e -c \"#{bin}/tio /dev/null\"", 1).strip
    end
    assert_match expected, output
  end
end
