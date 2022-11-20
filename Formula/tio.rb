class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v2.3/tio-2.3.tar.xz"
  sha256 "77b485aafa3aa8e01fc2976ac547e7769c1c338bac41eeb7c1ec6fc0cc7ee5cd"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0361e1b49050bbf4fbfde6cb7fc25b07bcd3b4179e1e2f408f047525d489d897"
    sha256 cellar: :any,                 arm64_monterey: "76721af8c30562c7d06181c2415fdb8d50786acbb6917b565a1c3128fed4e065"
    sha256 cellar: :any,                 arm64_big_sur:  "e0552f02e79c7854bd662c9963e8f3a7c1ab430fbde31d55a897b59d6189872b"
    sha256 cellar: :any,                 ventura:        "6d305b137300afba7c4ac88192bd0c2f47c35a9c35a5ec85bfe0bf496089d5e5"
    sha256 cellar: :any,                 monterey:       "7d03260ad27a4e06f326390acb97d5181566c2b4fcd2b66adfea39e5e71e7de0"
    sha256 cellar: :any,                 big_sur:        "75e54dd13513d37a8de837d76229ec2915747f2313d5c1ea79a5b9a41549ce46"
    sha256 cellar: :any,                 catalina:       "65d6b3cf2a69c7f27678492e71e968abeab4048cd0671435692c6dea3d7bf4e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cee1d51f36f1d51a91c1b1fed61a9639f64db923dacad697e18de3a24ccd8e22"
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
