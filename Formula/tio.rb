class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v1.37/tio-1.37.tar.xz"
  sha256 "a54cd09baeaabd306fdea486b8161eea6ea75bb970b27cae0e8e407fb2dd7181"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "86b3ea95b85f3e8d833026c4f12920822683f78418c997cbbc634d9cd9ae97ac"
    sha256 cellar: :any, arm64_big_sur:  "f1a58b0db83d70d16cb762bab607b273e18405da5acb57ce6cb6a32a6fc05139"
    sha256 cellar: :any, monterey:       "6e52fa8b8f95a4117fde4607d28839965dcdf510fab7f3335bb1f8f3790b70fd"
    sha256 cellar: :any, big_sur:        "98e16d3bd13972b3c219d6bf3b06cd0df4ca3bf5c2b1f28093a07f393de9537c"
    sha256 cellar: :any, catalina:       "96b24ccbf28fc0664a6651948d9fe10166667a8d11d105b5474e34cd18cc2ba6"
    sha256               x86_64_linux:   "5b58bd33e112c74a0261ebd2841959a00ba89fc640397a905b9eb7570add5436"
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
