class Ssldump < Formula
  desc "SSLv3/TLS network protocol analyzer"
  homepage "https://ssldump.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ssldump/ssldump/0.9b3/ssldump-0.9b3.tar.gz"
  sha256 "6422c16718d27c270bbcfcc1272c4f9bd3c0799c351f1d6dd54fdc162afdab1e"
  revision 2

  # This regex intentionally matches unstable versions, as only a beta version
  # (0.9b3) is available at the time of writing.
  livecheck do
    url :stable
    regex(%r{url=.*?/ssldump/([^/]+)/[^/]+\.t}i)
  end

  bottle do
    cellar :any
    sha256 "4227a45957205b7e183b9f66f4ad2cd57abd7eda44db220d0feadf4de03b5778" => :catalina
    sha256 "940b872d8dd649cc7ef309bb169a02a48425b7059c44c012831fafd5cbe8b61e" => :mojave
    sha256 "096ee72c50d64cddefb9d90f2b9c904322eaf36eab4c76bb914a60387b75baf9" => :high_sierra
  end

  depends_on "libpcap"
  depends_on "openssl@1.1"

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
                          "--with-pcap=#{Formula["libpcap"].opt_prefix}",
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
