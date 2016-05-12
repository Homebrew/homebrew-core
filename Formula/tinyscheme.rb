class Tinyscheme < Formula
  desc "Very small Scheme implementation"
  homepage "http://tinyscheme.sourceforge.net"
  url "https://downloads.sourceforge.net/project/tinyscheme/tinyscheme/tinyscheme-1.41/tinyscheme-1.41.tar.gz"
  sha256 "eac0103494c755192b9e8f10454d9f98f2bbd4d352e046f7b253439a3f991999"

  bottle do
    revision 1
    sha256 "fce84a2d2929ad1118015add67416e61b7d2911fbf99ab11c679aeebad6318f3" => :el_capitan
    sha256 "d23514b5d1f4c1f3360ce6773bcb2aff49986c013da608989a169149357966b4" => :yosemite
    sha256 "80d65369497ac62f490ec9818a11b8391db77382b924f67bbabc18f788fdf39e" => :mavericks
  end
  fails_with :clang

  # Modify compile flags for Mac OS X per instructions
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/2f905ea0/tinyscheme/patch-makefile.diff"
    sha256 "a50147cf63c5d5bd3f3d6ce84cd5f4d2d06f55222dc2a9a17b6da7d9893e0586"
  end

  def install
    system "make", "INITDEST=#{share}"
    lib.install("libtinyscheme.dylib")
    share.install("init.scm")
    bin.install("scheme")
  end

  test do
    (testpath/"hello.scm").write <<-EOS.undent
      (display "Hello, World!") (newline)
    EOS
    cp share/"init.scm", testpath
    system "echo", "A"
    assert_match "Usage: tinyscheme", shell_output("#{bin}/scheme -? 2>&1", 1)
    system "echo", "B"
    `#{bin}/scheme hello.scm`
    system "echo", "C"
    assert_equal "Hello, World!", shell_output("#{bin}/scheme hello.scm 2>&1").chomp
    system "echo", "D"
    assert_match /Hello, World/, pipe_output("#{bin}/scheme -1 - 2>&1", File.read(testpath/"hello.scm"))
    rm "init.scm"
    system "echo", "E"
    assert_match "Hello, World!", shell_output("#{bin}/scheme hello.scm 2>&1").chomp
  end
end
