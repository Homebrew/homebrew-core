class Srecord < Formula
  desc "Tools for manipulating EPROM load files"
  homepage "https://srecord.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/srecord/srecord/1.64/srecord-1.64.tar.gz"
  sha256 "49a4418733c508c03ad79a29e95acec9a2fbc4c7306131d2a8f5ef32012e67e2"

  bottle do
    cellar :any
    sha256 "cc4e1e89835954876853f5f7bcccbfd172adbb5651c1f2790ea3da10e4347845" => :catalina
    sha256 "6b3b825b501d1ea1635d107fb62021dde713f6da375f53f1a1fdcb59070df63a" => :mojave
    sha256 "f6341ba9022e6cbc057c519fcdc7c7518247c850025777b80d2463341315d88c" => :high_sierra
    sha256 "0601896fc392a13f7ef861fc3840fadfc7ddc7313763c1d374555129f4301c0d" => :sierra
    sha256 "6a0df3e5fb40699d9b1198562b3b3a4e1745c3a0d12923c461246b7784b8324c" => :el_capitan
    sha256 "c3c29b357c44bc3da2dbb8f23a6d83aeb637aa374fe0564eb9454e5e6b53d54c" => :yosemite
    sha256 "10a04c2aca5e6f554c00aa57bd05f9c3cbe46238c9af66678dc1e6a3323c5cdb" => :mavericks
  end

  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "libgcrypt"

  # Use macOS's pstopdf
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "LIBTOOL=glibtool"
    system "make", "install"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index b669f1a..b03c002 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -151,7 +151,7 @@ the-default-target: all
 
 etc/BUILDING.pdf: etc/BUILDING.man
 	$(GROFF) -Tps -s -I. -t -man etc/BUILDING.man > etc/BUILDING.ps
-	ps2pdf etc/BUILDING.ps $@
+	pstopdf etc/BUILDING.ps $@
 	rm etc/BUILDING.ps
 
 $(datarootdir)/doc/srecord/BUILDING.pdf: .mkdir.__datarootdir__doc_srecord \
@@ -181,7 +181,7 @@ etc/README.pdf: etc/README.man etc/new.1.1.so etc/new.1.10.so etc/new.1.11.so \
 		etc/new.1.60.so etc/new.1.61.so etc/new.1.62.so \
 		etc/new.1.63.so etc/new.1.7.so etc/new.1.8.so etc/new.1.9.so
 	$(GROFF) -Tps -s -I. -t -man etc/README.man > etc/README.ps
-	ps2pdf etc/README.ps $@
+	pstopdf etc/README.ps $@
 	rm etc/README.ps
 
 $(datarootdir)/doc/srecord/README.pdf: .mkdir.__datarootdir__doc_srecord \
@@ -209,7 +209,7 @@ etc/change_log.pdf: etc/change_log.man etc/new.1.1.so etc/new.1.10.so \
 		etc/new.1.62.so etc/new.1.63.so etc/new.1.7.so etc/new.1.8.so \
 		etc/new.1.9.so
 	$(GROFF) -Tps -s -I. -t -man etc/change_log.man > etc/change_log.ps
-	ps2pdf etc/change_log.ps $@
+	pstopdf etc/change_log.ps $@
 	rm etc/change_log.ps
 
 $(datarootdir)/doc/srecord/change_log.pdf: .mkdir.__datarootdir__doc_srecord \
@@ -283,7 +283,7 @@ etc/reference.pdf: etc/BUILDING.man etc/README.man etc/coding-style.so \
 		man/man5/srec_ti_txt.5 man/man5/srec_trs80.5 \
 		man/man5/srec_vmem.5 man/man5/srec_wilson.5
 	$(GROFF) -Tps -s -I. -t -man etc/reference.man > etc/reference.ps
-	ps2pdf etc/reference.ps $@
+	pstopdf etc/reference.ps $@
 	rm etc/reference.ps
 
 $(datarootdir)/doc/srecord/reference.pdf: .mkdir.__datarootdir__doc_srecord \
