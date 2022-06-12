class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v1.39/tio-1.39.tar.xz"
  sha256 "28cffbe6a09440b233e941688b5828459878a4c390720bf444f3d3905c2a7094"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "530eed9eae90dc2bcc731101ae887c1c0db9ddf61fd01a008b5df7669cc4d546"
    sha256 cellar: :any,                 arm64_big_sur:  "2a76da6680bbd4354a010d79d64f256599d4b1687a946c4187e3979773a20efc"
    sha256 cellar: :any,                 monterey:       "bd7d64ec64e56bec794529239125c1e8223a4f0ddc2edb2d1d4f07018db1e46f"
    sha256 cellar: :any,                 big_sur:        "59bd9132a9d6846548159e2f0f4d960434029eb4ae4ce49b8874601e1fd7e4ec"
    sha256 cellar: :any,                 catalina:       "6bf004a5c55730bb95e4d5194e4357ac7bad35a70af262ebda7581132ce4839d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f94d5f84a07eaadc61bdcdc518f375c6ebde7eeaa0919bdb6d4d1a49822b4e3f"
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
