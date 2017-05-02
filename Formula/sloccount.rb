class Sloccount < Formula
  desc "Count lines of code in many languages"
  homepage "https://www.dwheeler.com/sloccount/"
  url "https://www.dwheeler.com/sloccount/sloccount-2.26.tar.gz"
  sha256 "fa7fa2bbf2f627dd2d0fdb958bd8ec4527231254c120a8b4322405d8a4e3d12b"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6ae6d6442fc33e0aa5302fc99535ad79507067960226533a64e8332a1aaeaae" => :sierra
    sha256 "9fe12539b280711faac5e0950b617ed91f35942311aab112607850645b5696bd" => :el_capitan
    sha256 "8ee5aab0e8aba23cb6d949c84760fa775473b32b6ce3e245ccb5acfd715f8d68" => :yosemite
    sha256 "16433612bab2bc3fd6d3b804210c1d71980756b02e5e034aa9402c8229e1c968" => :mavericks
  end

  depends_on "md5sha1sum"

  patch :DATA

  def install
    rm "makefile.orig" # Delete makefile.orig or patch falls over
    bin.mkpath # Create the install dir or install falls over
    system "make", "install", "PREFIX=#{prefix}"
    (bin+"erlang_count").write "#!/bin/sh\ngeneric_count '%' $@"
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
