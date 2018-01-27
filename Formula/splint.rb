class Splint < Formula
  desc "Secure Programming Lint"
  homepage "https://sourceforge.net/projects/splint/"
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/splint/splint-3.1.2.src.tgz"
  mirror "http://pkgs.fedoraproject.org/repo/pkgs/splint/splint-3.1.2.src.tgz/25f47d70bd9c8bdddf6b03de5949c4fd/splint-3.1.2.src.tgz"
  sha256 "c78db643df663313e3fa9d565118391825dd937617819c6efc7966cdf444fb0a"

  bottle do
    sha256 "4d97939d58a64670256ea18422ae7ddd75ea1d12e89d12f40faa0b54e6d9d3a8" => :high_sierra
    sha256 "e5847a77e137e1f2339b55ae1fff93a94de33c6ad1a3a34c8a45b3d06a6bf0f9" => :sierra
    sha256 "9eac9f8e530c1d9fc238b57f9d4e143fbf5727450657ba92e6d721660777753b" => :el_capitan
    sha256 "4b385e4fcf9b82fa2ebd8dabaef7e712039b3f7c83d2f6d5e3263ebf51e7b6d7" => :yosemite
    sha256 "ad8551b508f303c69499a60456de49d2b77d1f0f2383383d3c01c1b657a230b6" => :mavericks
  end

  # fix compiling error of osd.c
  patch :DATA

  def install
    ENV.deparallelize # build is not parallel-safe
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    path = testpath/"test.c"
    path.write <<~EOS
      #include <stdio.h>
      int main()
      {
          char c;
          printf("%c", c);
          return 0;
      }
    EOS

    output = shell_output("#{bin}/splint #{path} 2>&1", 1)
    assert_match "5:18: Variable c used before definition", output
  end
end


__END__
diff --git a/src/osd.c b/src/osd.c
index ebe214a..4ba81d5 100644
--- a/src/osd.c
+++ b/src/osd.c
@@ -516,7 +516,7 @@ osd_getPid ()
 # if defined (WIN32) || defined (OS2) && defined (__IBMC__)
   int pid = _getpid ();
 # else
-  __pid_t pid = getpid ();
+  pid_t pid = getpid ();
 # endif

   return (int) pid;
