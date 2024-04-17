class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v2.8/tio-2.8.tar.xz"
  sha256 "890a880a048e604dbb9c3765d10b3dcdd2bb54cecf7b4bcc3a1ac0f3b6c95706"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "d68fe6d6246e670c617686c1a6552afc5feee7aebfa730fc3f813d39df13dcf4"
    sha256 cellar: :any, arm64_ventura:  "3b20986db04488e76e4c53fa18e2c16ad2c431ffbab95db7702e2bd27914802b"
    sha256 cellar: :any, arm64_monterey: "23cf72d767e0f99b776e084df3771872b84616c0deaad37ba041e4ff819a80c7"
    sha256 cellar: :any, sonoma:         "c487587214ba468a86a62d50a1fbed8c63ff05dfeca77c4ee2987d582c3060f6"
    sha256 cellar: :any, ventura:        "14089cf5183f1938f96713a18677393d602eeeeccf03c8272bc7c498b40c144d"
    sha256 cellar: :any, monterey:       "e313b311033ba3a10038f27c222965606b0f2b27847afe6367e3ff5001ed5908"
    sha256               x86_64_linux:   "6d06650926497403d4e52c564be61c233415967307ff38415e60e11a327e5a62"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "inih"
  depends_on "lua"

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
