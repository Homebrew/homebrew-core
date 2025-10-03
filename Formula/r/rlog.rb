class Rlog < Formula
  desc "Flexible message logging facility for C++"
  homepage "https://github.com/vgough/rlog"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/rlog/rlog-1.4.tar.gz"
  sha256 "a938eeedeb4d56f1343dc5561bc09ae70b24e8f70d07a6f8d4b6eed32e783f79"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "abe2bf8a021e632b0e828b667b5e2e09be2cb2bf5356b40adc7787248c16b12e"
    sha256 cellar: :any,                 arm64_sequoia:  "17aeadbbb0c7138389b80f0cecf0c59b6a329176eda02d38a9566502110f72f4"
    sha256 cellar: :any,                 arm64_sonoma:   "408100778814811a72a063dd53302248c2d291baa55534a3a58daf16a14a1ffe"
    sha256 cellar: :any,                 arm64_ventura:  "d33c09168d248f72b7c81e8a61f3d8f69a1d13127f8f75d7526a28220e5d7f4c"
    sha256 cellar: :any,                 arm64_monterey: "cd251b465737a2c5d9cd4aaeff4a625d1c48d50778bc8c93ad4e683b04ca82c5"
    sha256 cellar: :any,                 arm64_big_sur:  "543009caf7c0dede6026949c6ccd5569183cabd78414542efcc3a43ae1a25cfa"
    sha256 cellar: :any,                 sonoma:         "d1e8d4a9e1765d6d916b4c5882bc88ef3eaeb277d5de3384a922c4d680003521"
    sha256 cellar: :any,                 ventura:        "d9647143281d40fc2b06eedacdea150af04bc014a9d0e9a912bbb45ad4b40179"
    sha256 cellar: :any,                 monterey:       "239d339429358a6e685e6793eee4c528008eeeb40731b4c6cfa44f2ca571adf4"
    sha256 cellar: :any,                 big_sur:        "4d6953945346cc4b3548510ebad0bd441246101be7c7a8c633b98c6e94c9fdaa"
    sha256 cellar: :any,                 catalina:       "42b1e5a687f78df9121a75bc0b1194a534f31b8476521592879ea5fe381d634f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5bde76b56501c03e8394ffb8302a2e80523b25b64a664ab6155a49a71a7ef88c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a272cb9d709fffe4c798d278a49455a5a05a0e4c408e158609b168718b9c5e1b"
  end

  patch :DATA

  def install
    # Fix flat namespace usage
    inreplace "configure", "${wl}-flat_namespace ${wl}-undefined ${wl}suppress", "${wl}-undefined ${wl}dynamic_lookup"

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <stdio.h>
      #include <unistd.h>
      #include <rlog/rlog.h>
      #include <rlog/RLogChannel.h>
      #include <rlog/RLogNode.h>
      #include <rlog/StdioNode.h>
      int main(int argc, char **argv)
      {
          rlog::RLogInit(argc, argv);
          rlog::StdioNode stdLog(STDOUT_FILENO);
          stdLog.subscribeTo(rlog::GetGlobalChannel(""));
          const char *name = "Dave";
          rDebug("num = %i", 299792458);
          int ans = 6 * 9;
          if (ans != 42) rWarning("ans = %i, expecting 42", ans);
          rError("I'm sorry %s, I can't do that.", name);
      }
    CPP

    expected_outputs = [
      "(test.cpp:13) num = 299792458",
      "(test.cpp:15) ans = 54, expecting 42",
      "(test.cpp:16) I'm sorry Dave, I can't do that.",
    ]

    system ENV.cxx, "-I#{include}", "-L#{lib}", "test.cpp", "-lrlog", "-o", "test"
    output = shell_output("./test")
    expected_outputs.each do |expected|
      assert_match expected, output
    end
  end
end

# This patch solves an OSX build issue, should not be necessary for the next release according to
# https://code.google.com/p/rlog/issues/detail?id=7
__END__
--- orig/rlog/common.h.in	2008-06-14 20:10:13.000000000 -0700
+++ new/rlog/common.h.in	2009-05-18 16:05:04.000000000 -0700
@@ -52,7 +52,12 @@

 # define PRINTF(FMT,X) __attribute__ (( __format__ ( __printf__, FMT, X)))
 # define HAVE_PRINTF_ATTR 1
+
+#ifdef __APPLE__
+# define RLOG_SECTION __attribute__ (( section("__DATA, RLOG_DATA") ))
+#else
 # define RLOG_SECTION __attribute__ (( section("RLOG_DATA") ))
+#endif

 #if __GNUC__ >= 3
 # define expect(foo, bar) __builtin_expect((foo),bar)
