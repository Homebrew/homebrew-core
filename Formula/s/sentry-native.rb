class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/releases/download/0.16.6/sentry-native.zip"
  sha256 "d35145daaafddc50c0c87ec564acf0ba9968e67b23981e7f57c702b2dd6f2ff1"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "0560ea1c6d5f459b856aea7ca16f9b5635a4e1d57fa6735d63d31f086b9fd52f"
    sha256 cellar: :any, arm64_tahoe:       "b0eac9f6121c860f33900ca68fc7adb22666a92619a1c347263f4c3e3a4d4732"
    sha256 cellar: :any, arm64_sequoia:     "57785f6c3cb1b53dc09a1162a97dec578c66411368476fdea3f54f039d0a1c8e"
    sha256 cellar: :any, arm64_sonoma:      "9b48fdba80db1bc8ee59fd6570cc808238e2324407234f8a23c34eee9e43b96d"
    sha256 cellar: :any, arm64_linux:       "9cd394e56f4752a3055e935198bfdd150f1d18ed0c01ab366060b88147b01364"
    sha256 cellar: :any, x86_64_linux:      "e9891cc27f8255dbca46121bb178af0114d72534a011e12791941d2de4157abf"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
  end

  def install
    rm_r("vendor/libunwind")

    args = %w[
      -DSENTRY_BUILD_EXAMPLES=OFF
      -DSENTRY_BUILD_TESTS=OFF
    ]
    args << "-DSENTRY_LIBUNWIND_SYSTEM=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <sentry.h>
      int main() {
        sentry_options_t *options = sentry_options_new();
        sentry_options_set_dsn(options, "https://ABC.ingest.us.sentry.io/123");
        sentry_init(options);
        sentry_close();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{HOMEBREW_PREFIX}/include", "-L#{HOMEBREW_PREFIX}/lib", "-lsentry", "-o", "test"
    system "./test"
  end
end
