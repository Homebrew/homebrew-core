class Xvid < Formula
  desc "High-performance, high-quality MPEG-4 video library"
  homepage "https://labs.xvid.com/"
  url "https://downloads.xvid.com/downloads/xvidcore-1.3.7.tar.bz2"
  sha256 "aeeaae952d4db395249839a3bd03841d6844843f5a4f84c271ff88f7aa1acff7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://downloads.xvid.com/downloads/"
    regex(/href=.*?xvidcore[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "3a95088d2a638b37179758a0abdc7324ab03097b02f2216b67989ae87d3b3892"
    sha256 cellar: :any,                 arm64_sequoia: "e7e300ab7d6f6872713f63145b650c66d0d9841a691eb44c4ab3adf06ce57f33"
    sha256 cellar: :any,                 arm64_sonoma:  "ea6039c190cc6453cff9503a8db8142fd72c70287c9fe880e90d71eb4e83131a"
    sha256 cellar: :any,                 sonoma:        "59d0e5210d62d77f4d08f85ba6dcf57870b953ff25f29d1cce1d38da0a4bcc42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "343db5afde898a2804e5a7a2269ef6ca4e50926a825991e33c3615c3ee35ba93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c455a429edf2c2723ab4aca880bd1827ff028b01a2799142fa1f9469006587f"
  end

  # Remove -flat_namespace based on MacPorts patch (which needs autoreconf).
  # https://github.com/macports/macports-ports/blob/master/multimedia/XviD/files/configure-flat_namespace.patch
  # They reported issue via email: https://trac.macports.org/ticket/69855#comment:10
  on_macos do
    patch :DATA
  end

  def install
    cd "build/generic" do
      system "./configure", "--disable-assembly", "--prefix=#{prefix}"
      ENV.deparallelize # Work around error: install: mkdir =build: File exists
      system "make"
      system "make", "install"
    end

    # Create unversioned symlink to use shared library
    if OS.mac?
      libxvidcore = shared_library("libxvidcore")
      odie "Remove manual symlink!" if (lib/libxvidcore).exist?
      lib.install_symlink lib.glob(shared_library("libxvidcore", "*")).first => libxvidcore
    end
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <xvid.h>
      #define NULL 0
      int main() {
        xvid_gbl_init_t xvid_gbl_init;
        xvid_global(NULL, XVID_GBL_INIT, &xvid_gbl_init, NULL);
        return 0;
      }
    CPP
    system ENV.cc, "test.cpp", "-L#{lib}", "-lxvidcore", "-o", "test"
    system "./test"
  end
end

__END__
--- a/build/generic/configure
+++ b/build/generic/configure
@@ -4404,7 +4404,7 @@ $as_echo "ok" >&6; }
 	   { $as_echo "$as_me:${as_lineno-$LINENO}: result: dylib options" >&5
 $as_echo "dylib options" >&6; }
 	   SHARED_LIB="libxvidcore.\$(API_MAJOR).\$(SHARED_EXTENSION)"
-	   SPECIFIC_LDFLAGS="-Wl,-read_only_relocs,suppress -dynamiclib -flat_namespace -compatibility_version \$(API_MAJOR) -current_version \$(API_MAJOR).\$(API_MINOR) -install_name \$(libdir)/\$(SHARED_LIB)"
+	   SPECIFIC_LDFLAGS="-Wl,-read_only_relocs,suppress -dynamiclib -compatibility_version \$(API_MAJOR) -current_version \$(API_MAJOR).\$(API_MINOR) -install_name \$(libdir)/\$(SHARED_LIB)"
 	else
 	   { $as_echo "$as_me:${as_lineno-$LINENO}: result: module options" >&5
 $as_echo "module options" >&6; }
