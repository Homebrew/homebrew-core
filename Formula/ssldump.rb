class Ssldump < Formula
  desc "SSLv3/TLS network protocol analyzer"
  homepage "https://ssldump.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ssldump/ssldump/0.9b3/ssldump-0.9b3.tar.gz"
  sha256 "6422c16718d27c270bbcfcc1272c4f9bd3c0799c351f1d6dd54fdc162afdab1e"

  bottle do
    cellar :any
    sha256 "81814f2ed4a43f89f2bce76f316a11f6adf36b46cab132c69566ab465bb18b41" => :mojave
    sha256 "f61685cdc0a75d520d823508f76ad11a3bd6b3f76c2c0da85045f8a47155f4e2" => :high_sierra
    sha256 "e1b49cff5781b5c030696757f3edba544c2bd58a50486962c8cbf0cd3b005da3" => :sierra
    sha256 "a468350638d8d0e66e8fe137b1473a25e300b967cadae1652e062f9cd92f2dbb" => :el_capitan
    sha256 "714f3e5283285dea18ba6bfc27f3dda2fc9d1317c6fe269fd4ba84aba44fe44c" => :yosemite
    sha256 "61b20e42893e904872f075064323366aa29e05fc3bab4a2d09265e6e05189532" => :mavericks
    sha256 "835adb0d5cdf60701acfa0a760653149cc03eff2759e7c1c4766737ee1f64ac7" => :mountain_lion
  end

  depends_on "openssl"

  # reorder include files
  # https://sourceforge.net/p/ssldump/bugs/40/
  # increase pcap sample size from an arbitrary 5000 the max TLS packet size 18432
  patch :DATA

  def install
    ENV["LIBS"] = "-lssl -lcrypto"

    # .dylib, not .a
    inreplace "configure", "if test -f $dir/libpcap.a; then",
                           "if test -f $dir/libpcap.dylib; then"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "osx"
    system "make"
    # force install as make got confused by install target and INSTALL file.
    system "make", "install", "-B"
  end

  test do
    system "#{sbin}/ssldump", "-v"
  end
end

__END__
--- a/base/pcap-snoop.c	2010-03-18 22:59:13.000000000 -0700
+++ b/base/pcap-snoop.c	2010-03-18 22:59:30.000000000 -0700
@@ -46,10 +46,9 @@
 
 static char *RCSSTRING="$Id: pcap-snoop.c,v 1.14 2002/09/09 21:02:58 ekr Exp $";
 
-
+#include <net/bpf.h>
 #include <pcap.h>
 #include <unistd.h>
-#include <net/bpf.h>
 #ifndef _WIN32
 #include <sys/param.h>
 #endif
--- a/base/pcap-snoop.c	2012-04-06 10:35:06.000000000 -0700
+++ b/base/pcap-snoop.c	2012-04-06 10:45:31.000000000 -0700
@@ -286,7 +286,7 @@
           err_exit("Aborting",-1);
         }
       }
-      if(!(p=pcap_open_live(interface_name,5000,!no_promiscuous,1000,errbuf))){
+      if(!(p=pcap_open_live(interface_name,18432,!no_promiscuous,1000,errbuf))){
 	fprintf(stderr,"PCAP: %s\n",errbuf);
 	err_exit("Aborting",-1);
       }
