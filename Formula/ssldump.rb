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
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "4e68e15e5fd410822495680f04ce90f9c45b462ebdc5512c8c49b51bbc4bfd40"
    sha256 cellar: :any,                 arm64_big_sur:  "51fc5984a5f7dbef4c4299458e60a8ebdbe88d69c3422a8883863fafa63b9854"
    sha256 cellar: :any,                 monterey:       "74dd546d763c9bda4fd915e6b60cd24c333c0f3aa9dacd258b473dafa04b0277"
    sha256 cellar: :any,                 big_sur:        "27b04d713522d2937232b457ee32a2293cc9c633acee5efc147ae3fa84741da2"
    sha256 cellar: :any,                 catalina:       "4f05ecf010a75b92ce19c9889759484f7f4e337e2659516be3c87fe02d99c9ed"
    sha256 cellar: :any,                 mojave:         "3c9186ee97ff509fd83a0e81acc06e621d50701bcf94e15ce61e4edbbb1b9796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "101d9148eb4db18bc3993815a813ae25ba23f5babaa7c67a3db739ca40f77e87"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libpcap"
  depends_on "openssl@1.1"

  # reorder include files
  # https://sourceforge.net/p/ssldump/bugs/40/
  # increase pcap sample size from an arbitrary 5000 the max TLS packet size 18432
  patch :DATA

  def install
    ENV["LIBS"] = "-lssl -lcrypto"

    # .dylib, not .a
    inreplace "configure.in", "if test -f $dir/libpcap.a; then",
                              "if test -f $dir/#{shared_library("libpcap")}; then"

    # The configure file that ships in the 0.9b3 tarball is too old to work
    # with Xcode 12
    system "autoreconf", "--verbose", "--install", "--force"

    # Normally we'd get these files installed as part of autoreconf.  However,
    # this project doesn't use Makefile.am so they're not brought in.  The copies
    # in the 0.9b3 tarball are too old to detect MacOS
    %w[config.guess config.sub].each do |fn|
      cp "#{Formula["automake"].opt_prefix}/share/automake-#{Formula["automake"].version.major_minor}/#{fn}", fn
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-pcap=#{Formula["libpcap"].opt_prefix}"
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
 #include <pcap.h>
 #include <unistd.h>
-#include <net/bpf.h>
+#include <pcap-bpf.h>
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
