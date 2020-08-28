class Sloccount < Formula
  desc "Count lines of code in many languages"
  homepage "https://www.dwheeler.com/sloccount/"
  url "https://www.dwheeler.com/sloccount/sloccount-2.26.tar.gz"
  sha256 "fa7fa2bbf2f627dd2d0fdb958bd8ec4527231254c120a8b4322405d8a4e3d12b"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?sloccount[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "11a3ecc7f2a5bbc0f2bb4836e03c799049b3bada8438220dcd827ca37fd2a200" => :catalina
    sha256 "b9a52de5de2a1be5fd606412ab8db8a55279da49d79f9812d59294a587aaa7c4" => :mojave
    sha256 "04a4c12a83cb655a8f2f69178905af19e2786927ef7a4e9d0020e870ce35fcbd" => :high_sierra
  end

  uses_from_macos "flex" => :build

  patch do
    url "https://sourceforge.net/p/sloccount/patches/21/attachment/sloccount-suppress-exec-warnings.patch"
    sha256 "4e68a7d9c61d62d4b045d1e5d099c6853456d15f874d659f3ab473e7fc40d565"
  end

  patch :DATA

  def install
    rm "makefile.orig" # Delete makefile.orig or patch falls over
    bin.mkpath # Create the install dir or install falls over
    system "make", "install", "PREFIX=#{prefix}"
    (bin+"erlang_count").write "#!/bin/sh\ngeneric_count '%' $@"
  end

  test do
    system "#{bin}/sloccount", "--version"
  end
end

__END__
diff --git a/break_filelist b/break_filelist
index ad2de47..ff854e0 100755
--- a/break_filelist
+++ b/break_filelist
@@ -205,6 +205,7 @@ $noisy = 0;            # Set to 1 if you want noisy reports.
   "hs" => "haskell", "lhs" => "haskell",
    # ???: .pco is Oracle Cobol
   "jsp" => "jsp",  # Java server pages
+  "erl" => "erlang",
 );
