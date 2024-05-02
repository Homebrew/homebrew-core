class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v3.0/tio-3.0.tar.xz"
  sha256 "b7ec8eab6c29a3821e3f1239cf6baa84ef634ea2188ffa93d7a276c89338961e"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "7c1a93f989bbc9af7810ba6de79ba678d8ea94b206980de7b170132f09c0f537"
    sha256 cellar: :any, arm64_ventura:  "776a11123270b9c043281faf7ee48c0af30cf7f10725a4148089d05e06a3842c"
    sha256 cellar: :any, arm64_monterey: "f03d33163787450133b926a49d6ebc34600b0c050ef1fb9235981cc11f9efa7a"
    sha256 cellar: :any, sonoma:         "52077a5e29e64f457405df60fbdbaacb66986b0aefc35224031c5f8c493f809d"
    sha256 cellar: :any, ventura:        "938d9860e91578b867883a1b2bb50371afc20b6ec91e801495187a2bf4e4ec37"
    sha256 cellar: :any, monterey:       "0d787488fb7a5b53ab830eac919631bbddd32589bec50c5e602e6abeb37e3db9"
    sha256               x86_64_linux:   "8750aa5f544dd813a5afeb105ce29bc5c46d7bbc098fdce8b112aa8d02326cf4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "inih"
  depends_on "lua"

  # add macos build patch for `fs_get_creation_time`
  # upstream patch ref, https://github.com/tio/tio/pull/244
  patch do
    url "https://github.com/tio/tio/commit/c37cc145d726405fb853f366ddd037329914ca52.patch?full_index=1"
    sha256 "0d6463142fc24db2d45b5cc3cf59b0898e5c5b0e7656c6a21f3f679103d9607f"
  end

  def install
    system "meson", "setup", "build", "-Dbashcompletiondir=#{bash_completion}", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
