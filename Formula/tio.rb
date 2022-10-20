class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v2.2/tio-2.2.tar.xz"
  sha256 "c6eca507d25c972037052f399bf9ce22ec3acea0313172efadf56d73357f0f16"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "255e466a100670a9a8a2dac6cf2257efa8ed54b9d94f15915851257dceec4064"
    sha256 cellar: :any,                 arm64_big_sur:  "7a406b160c52ea1e3dbea5bc279d08943280a0cd7ab6cbfba03be76b49a33781"
    sha256 cellar: :any,                 monterey:       "d96ce2399c72a0b1a3651503e1eedd387a1c569199152ba15e9a9e41af73e67c"
    sha256 cellar: :any,                 big_sur:        "3bda0948a04e8bc08435f80aa507e0ee9e47ba5c665d9b34dc617bdabb4ea773"
    sha256 cellar: :any,                 catalina:       "194b3d80a1d80f1412666bc04c974e1bb5531014b25875bc96fb377df11de761"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34046f9986cce7e6de72125d51f34ade1b78a0572a9aa6f6e5d6a9ff129e18e3"
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
