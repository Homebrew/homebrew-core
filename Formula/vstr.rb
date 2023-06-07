class Vstr < Formula
  desc "C string library"
  homepage "http://www.and.org/vstr/"
  url "http://www.and.org/vstr/1.0.15/vstr-1.0.15.tar.bz2"
  sha256 "d33bcdd48504ddd21c0d53e4c2ac187ff6f0190d04305e5fe32f685cee6db640"
  license "LGPL-2.1"

  livecheck do
    url "http://www.and.org/vstr/latest/"
    regex(/href=.*?vstr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "50f3aa1e3a2842093e6ce37468ff013c81ca97b948fb3d7b11f66c58b95f108b"
    sha256 cellar: :any,                 arm64_monterey: "dd5f9608d327370e2be19fa4c7aaa756db7b505a192dab7ebeedf413e379f53d"
    sha256 cellar: :any,                 arm64_big_sur:  "3c181dc7e473ded8e40136b7779a8e24859bbef80a60e627fb3a2672e43609cb"
    sha256 cellar: :any,                 ventura:        "dfb9e211db08192d08eb31c1928a9664f102662bf97324dff1e8e2a1616882c3"
    sha256 cellar: :any,                 monterey:       "029df7c0188636bd34fdb8f2a26697f61cc140660623992ee38af2e1050417c5"
    sha256 cellar: :any,                 big_sur:        "cc1c69c834bde35ed9e0df8178e8e65d9ba5703fbf2cf896290aed6a7433c4b3"
    sha256 cellar: :any,                 catalina:       "adbf13e88473af357032472ac09af1230667c5010089089a3c223819ef74c7f6"
    sha256 cellar: :any,                 mojave:         "8927c49aa4daba57ffab9a9ea332504346467cf22c137af3e1a16b859318a0f5"
    sha256 cellar: :any,                 high_sierra:    "af6d9cc097c4eb9c1719496b2e29593763b5b17b279ef4c234d681cfe4174b37"
    sha256 cellar: :any,                 sierra:         "07e2b05d9908a847c72950532d3ed12771c856365c8747c8c5917da9a5ea4413"
    sha256 cellar: :any,                 el_capitan:     "d2d5b14e9ac589c782307e058e06815ad2408bbcf418ac721d3fac3be8b832a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8346f2277202db06584db705dcf754a00ca364c547791d911e7c3395072b1b6e"
  end

  depends_on "pkg-config" => :build

  # Fix flat namespace usage on macOS.
  patch :DATA

  def install
    ENV.append "CFLAGS", "--std=gnu89"
    ENV["ac_cv_func_stat64"] = "no" if Hardware::CPU.arm?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS

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
