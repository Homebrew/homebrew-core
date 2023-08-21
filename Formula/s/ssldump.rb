class Ssldump < Formula
  desc "SSLv3/TLS network protocol analyzer"
  homepage "https://ssldump.sourceforge.net/"
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
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "233c699efc6adbf54ae1e0877b8376d016492116785942fa9cb7b5e38d6ac174"
    sha256 cellar: :any,                 arm64_monterey: "a020925b76ade838f6462b00870256b47236390f4d185ffec7735ca33c6025fd"
    sha256 cellar: :any,                 arm64_big_sur:  "3ff8463d5dc460c8d5775c307c492af601d12e455a27b3a5b966cd97d43560f1"
    sha256 cellar: :any,                 ventura:        "728ec5ab844645fb4ccffebeda3cdaa8b99581261cae35ccd3193d6256aad34c"
    sha256 cellar: :any,                 monterey:       "041b163945f15d099482ef9d7e4fa584d484439e90f11a2e81af663d004cab87"
    sha256 cellar: :any,                 big_sur:        "747bc2115e5e70c9c38679cb13212f5b1a01266156b4c43756e209a5947b2523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb5412234f420bc697835b6ede35a28ff31d03b2219f55e89c93352f1a0a74ea"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libpcap"
  depends_on "openssl@3"

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
      cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, fn
    end

    system "./configure", *std_configure_args,
                          "--disable-debug",
                          "--disable-dependency-tracking",
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
