class Vstr < Formula
  desc "C string library"
  homepage "http://www.and.org/vstr/"
  url "http://www.and.org/vstr/1.0.15/vstr-1.0.15.tar.bz2"
  sha256 "d33bcdd48504ddd21c0d53e4c2ac187ff6f0190d04305e5fe32f685cee6db640"
  license "LGPL-2.1-or-later"

  livecheck do
    url "http://www.and.org/vstr/latest/"
    regex(/href=.*?vstr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "2725b8c09c36af9b495587022630130f5561972343fa3d91bba4de2773f7c76e"
    sha256 cellar: :any,                 arm64_sequoia:  "578ee5248bf780a885cfc3dc8a806949ded7af743c3be7e7c839fe4d190a43cd"
    sha256 cellar: :any,                 arm64_sonoma:   "54ad15b7c3afd4dadfe4f48c8da91b39efc16d597b9f7300dc67aab5c3f75a40"
    sha256 cellar: :any,                 arm64_ventura:  "50f3aa1e3a2842093e6ce37468ff013c81ca97b948fb3d7b11f66c58b95f108b"
    sha256 cellar: :any,                 arm64_monterey: "dd5f9608d327370e2be19fa4c7aaa756db7b505a192dab7ebeedf413e379f53d"
    sha256 cellar: :any,                 arm64_big_sur:  "3c181dc7e473ded8e40136b7779a8e24859bbef80a60e627fb3a2672e43609cb"
    sha256 cellar: :any,                 sonoma:         "e8a6083d5029f10cde668b105012a8302eafcdde1d497ea92d6af9fcbb14a33f"
    sha256 cellar: :any,                 ventura:        "dfb9e211db08192d08eb31c1928a9664f102662bf97324dff1e8e2a1616882c3"
    sha256 cellar: :any,                 monterey:       "029df7c0188636bd34fdb8f2a26697f61cc140660623992ee38af2e1050417c5"
    sha256 cellar: :any,                 big_sur:        "cc1c69c834bde35ed9e0df8178e8e65d9ba5703fbf2cf896290aed6a7433c4b3"
    sha256 cellar: :any,                 catalina:       "adbf13e88473af357032472ac09af1230667c5010089089a3c223819ef74c7f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a7507e113107828ddec905dfb3c2b373d11f676800cc342fdf080a12038df960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8346f2277202db06584db705dcf754a00ca364c547791d911e7c3395072b1b6e"
  end

  depends_on "pkgconf" => :build

  # Fix flat namespace usage on macOS.
  patch :DATA

  def install
    ENV.append "CFLAGS", "--std=gnu89"
    ENV["ac_cv_func_stat64"] = "no" if OS.mac? && Hardware::CPU.arm?

    args = ["--mandir=#{man}"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      // based on http://www.and.org/vstr/examples/ex_hello_world.c
      #define VSTR_COMPILE_INCLUDE 1
      #include <vstr.h>
      #include <errno.h>
      #include <err.h>
      #include <unistd.h>

      int main(void) {
        Vstr_base *s1 = NULL;

        if (!vstr_init())
          err(EXIT_FAILURE, "init");

        if (!(s1 = vstr_dup_cstr_buf(NULL, "Hello Homebrew\\n")))
          err(EXIT_FAILURE, "Create string");

        while (s1->len)
          if (!vstr_sc_write_fd(s1, 1, s1->len, STDOUT_FILENO, NULL)) {
            if ((errno != EAGAIN) && (errno != EINTR))
              err(EXIT_FAILURE, "write");
          }

        vstr_free_base(s1);
        vstr_exit();
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lvstr", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/configure b/configure
index 84b6b1b..ffa2faf 100755
--- a/configure
+++ b/configure
@@ -8313,7 +8313,7 @@ if test -z "$aix_libpath"; then aix_libpath="/usr/lib:/lib"; fi
          ;;
        *) # Darwin 1.3 on
          if test -z ${MACOSX_DEPLOYMENT_TARGET} ; then
-           allow_undefined_flag='${wl}-flat_namespace ${wl}-undefined ${wl}suppress'
+           allow_undefined_flag='${wl}-undefined ${wl}dynamic_lookup'
          else
            case ${MACOSX_DEPLOYMENT_TARGET} in
              10.[012])
