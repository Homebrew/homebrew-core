class Xstow < Formula
  desc "Extended replacement for GNU Stow"
  homepage "http://xstow.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xstow/xstow-1.0.2.tar.bz2"
  sha256 "6f041f19a5d71667f6a9436d56f5a50646b6b8c055ef5ae0813dcecb35a3c6ef"

  bottle do
    sha256 "cbc066f33e9634a4a41e4288e8da74bafd2f7ea81952a72ebdf1227e9c1e3f8d" => :sierra
    sha256 "831ebc6209e25a8c85de9049ac3c7ff9c92155b3d23f792f9c768b963085cbb5" => :el_capitan
    sha256 "5584a4365068160f539ce883bb261b8a82f6be56331ea8abf55bc611126ea71b" => :yosemite
    sha256 "f8b4bd43dce5410280683721e4bbff8419a671f6764215d20bc4d17eddc00863" => :mavericks
  end

  # Patches to allow clang to compile
  # Patches from: https://svnweb.freebsd.org/ports?view=revision&revision=319588
  # Upstream bug report: https://sourceforge.net/p/xstow/bugs/7/
  patch :p0, :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-static", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/xstow", "-Version"
  end
end

__END__
diff -u src/string_utils.h~ src/string_utils.h
--- src/string_utils.h~	2013-06-01 23:10:50.000000000 +0300
+++ src/string_utils.h	2013-06-01 22:56:43.000000000 +0300
@@ -28,6 +28,9 @@
 #  define STRSTREAM
 #endif  
 
+typedef std::vector<std::string> vec_string;
+std::ostream& operator<<( std::ostream& out, const vec_string &v );
+
 std::string toupper( std::string s );
 std::string strip( const std::string& str, const std::string& what = " \t\n\0" );
 bool is_int( const std::string &s );
diff -u src/leoini.h~ src/leoini.h
--- src/leoini.h~	2013-06-01 22:28:45.000000000 +0300
+++ src/leoini.h	2013-06-01 22:32:05.000000000 +0300
@@ -260,11 +260,9 @@
 
     if( start == std::string::npos ||
 	end == std::string::npos )
-      s = "";
-    else
-      s = s.substr( start+1, start-end -1 );
+      return s2x<A>("");
 
-    return s2x<A>(s);
+    return s2x<A>(s.substr( start+1, start-end -1 ));
   }
 } // namespace Leo
 
