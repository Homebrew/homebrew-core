class Splint < Formula
  desc "Secure Programming Lint"
  homepage "https://github.com/splintchecker/splint"
  url "https://mirrorservice.org/sites/distfiles.macports.org/splint/splint-3.1.2.src.tgz"
  mirror "https://src.fedoraproject.org/repo/pkgs/splint/splint-3.1.2.src.tgz/25f47d70bd9c8bdddf6b03de5949c4fd/splint-3.1.2.src.tgz"
  sha256 "c78db643df663313e3fa9d565118391825dd937617819c6efc7966cdf444fb0a"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/^(?:splint[._-])?v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:    "3d26b806b15af6dde29829bdca6d9c0cc44ac7ef96d5522dee1cbd3f24a9924e"
    sha256                               arm64_sequoia:  "71b5c97c68f8d10d646955b1111d8556dc2f0ab90136dafd78f5beb673533fb3"
    sha256                               arm64_sonoma:   "b7570a4d7dbb53a9da6cc06e69bb7fd2a850829fe93ea39ffc14f494c4b1c58b"
    sha256                               arm64_ventura:  "6aae55c464e14dde1a9aa9f49da8e30d8184fcf12fbe06a9e913e1fc313455fa"
    sha256                               arm64_monterey: "f47715d1e6f0f201c2486f0d788fd138e89b86cd0c11477b3e5576fa49cffc83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "229d18ade0e3dfc1c9ed796732a57bb385de5dfd8c15d3b265c4ef42cfd5f765"
    sha256                               sonoma:         "a0123a9c0adb426819b56a79a095066f4aa2fa13c6bf501c212eb58e3cbe08b8"
    sha256                               ventura:        "2b3eaa69bb97239d281a12e678c4a5314413d3cc6543742fd67a6ec1e7d987a6"
    sha256                               monterey:       "fa3307d22e30d030cc844b92c91891cfe0581226726a7ad54e1cec82dec07189"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbe9dd0df4449df4259f44c16dc1505e6cdde38c0e7b7cc275d17ae974c8a3b2"
    sha256 cellar: :any_skip_relocation, catalina:       "98cc2bfccef60b21ec014ff35e71cc91a85e77435b4e429090e2767d0696bef8"
    sha256                               arm64_linux:    "6003db1cf73e332befaff1d85a5a3c547a094594e014b775cfe55914158dff58"
    sha256                               x86_64_linux:   "fded0340d91cfcbd99ddf5a89b505fd59895e980d86366654196192d6358a97c"
  end

  uses_from_macos "flex"

  # fix compiling error of osd.c
  patch :DATA

  def install
    ENV.deparallelize # build is not parallel-safe

    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--infodir=#{info}",
            "--mandir=#{man}"]

    args << "LEXLIB=#{Formula["flex"].opt_lib}/libfl.so" if OS.linux?
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    path = testpath/"test.c"
    path.write <<~C
      #include <stdio.h>
      int main()
      {
          char c;
          printf("%c", c);
          return 0;
      }
    C

    output = shell_output("#{bin}/splint #{path} 2>&1", 1)
    assert_match(/5:18:\s+Variable c used before definition/, output)
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
