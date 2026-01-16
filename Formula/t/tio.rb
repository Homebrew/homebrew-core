class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v3.9/tio-3.9.tar.xz"
  sha256 "06fe0c22e3e75274643c017928fbc85e86589bc1acd515d92f98eecd4bbab11b"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "31136d19c38be07ad62a597959f7477b9afbd9aaafeae6f88c8a55391fd35f0e"
    sha256 cellar: :any, arm64_sequoia: "d859f7a3951e0cf44e33cef1cd9fe1cf1f5ea2027e8a0f2f7241d802f6345528"
    sha256 cellar: :any, arm64_sonoma:  "815733f3d33d84e6b6f16a616dd4c1ee1dfea19d1310842579796c86c80d78d2"
    sha256 cellar: :any, arm64_ventura: "ef6cda9f15f7419c8786fde48e36050b8e0527d1ac9b7da60c701cd8be29893f"
    sha256 cellar: :any, sonoma:        "eff6132fd0c5bc4d35e5f44a97e8b7538881f3d35c75d45bb5ce58c7116fa024"
    sha256 cellar: :any, ventura:       "af299fc0c5b32da363167450793ca0ae78f40605353db850da9f9c684d384ffe"
    sha256               arm64_linux:   "42266b46a3364e7b85daec0a33922996016880c7905707dc23aead6a8baa3c9a"
    sha256               x86_64_linux:  "2a5457998f6b942835c7bcfdb22fb9673abaecf9dce98eb65c3ab67a18529aa9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

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
