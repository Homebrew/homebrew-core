class Zlib < Formula
  desc "General-purpose lossless data-compression library"
  homepage "https://zlib.net/"
  url "https://zlib.net/zlib-1.3.2.tar.gz"
  mirror "https://downloads.sourceforge.net/project/libpng/zlib/1.3.2/zlib-1.3.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zlib-1.3.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zlib-1.3.2.tar.gz"
  sha256 "bb329a0a2cd0274d05519d61c667c062e06990d72e125ee2dfa8de64f0119d16"
  license "Zlib"
  head "https://github.com/madler/zlib.git", branch: "develop"

  livecheck do
    url :homepage
    regex(/href=.*?zlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5457abac7b01f56603e06b1cbc17fbca5cc34fb82c78bf503cee99e5028a1bc3"
    sha256 cellar: :any,                 arm64_sequoia: "c43efaa12e3d22914f41882679ad8c86b58958660852f1edd7b305daee5860f0"
    sha256 cellar: :any,                 arm64_sonoma:  "ca032109db39a64b5eeb8d90a179c7d873f2de3f8b298f9546430d7b8cddc09f"
    sha256 cellar: :any,                 sonoma:        "14940211b29d719bcabe03e43d7c06086c9c436c391c5b33f273763c3110f8e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e606565d4ae9f860a4d15992140a8cb48fc33408d65d4e5d061d5ef2715069e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "352c7d94d5b64b31b636b3d0b3252a1a8ca82e1020a5b71c7be829667e278dcf"
  end

  keg_only :provided_by_macos

  on_linux do
    keg_only "it conflicts with zlib-ng-compat"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Avoid rebuilds of dependents that hardcode this path.
    inreplace lib/"pkgconfig/zlib.pc", prefix, opt_prefix
  end

  test do
    # https://zlib.net/zlib_how.html
    resource "zpipe.c" do
      url "https://raw.githubusercontent.com/madler/zlib/3f5d21e8f573a549ffc200e17dd95321db454aa1/examples/zpipe.c"
      mirror "http://zlib.net/zpipe.c"
      sha256 "e79717cefd20043fb78d730fd3b9d9cdf8f4642307fc001879dc82ddb468509f"
    end

    testpath.install resource("zpipe.c")
    system ENV.cc, "zpipe.c", "-I#{include}", "-L#{lib}", "-lz", "-o", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", text, 0)
    assert_equal text, pipe_output("./zpipe -d", compressed, 0)
  end
end
