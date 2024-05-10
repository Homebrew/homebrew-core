class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v3.2/tio-3.2.tar.xz"
  sha256 "9208e98dce783598a76c406f0b076f07dc0f645aaaab99ee5c3039744e8c0e2a"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "6cd4b5a965adc6f4e22103ef3fa56a025084da603bf36a22c34cfd4ba75f3d3b"
    sha256 cellar: :any, arm64_ventura:  "0bfdd42678b0aee2ef6e1ef400967e35b7ebd5bad731387db576d9806d5c87c7"
    sha256 cellar: :any, arm64_monterey: "4849dcfce16eacb014eb6d384398ee6f639b2b00b20f739147587cac1764bb54"
    sha256 cellar: :any, sonoma:         "a3d1b6dc8dcf529af8fcc2a3325749c7f81ddccc46a1a6a3876d1b2532406d28"
    sha256 cellar: :any, ventura:        "3dc1888720116a43060525f5c35e8ddacdbb2a5d68df06ef46f094004486fafe"
    sha256 cellar: :any, monterey:       "eb47adc6d0aebcc1f6e8b2a122c9b7ffafe0ee29d7216ac976d614ceae2a4d80"
    sha256               x86_64_linux:   "9dcca888fd2eb0da68f9947307d732e5c9a19a3dc5a650d7308bedf6db67b9e7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
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
