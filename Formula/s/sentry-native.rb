class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/releases/download/0.17.7/sentry-native.zip"
  sha256 "abd241373670bcdc35d8ecf8e557dd1555eb38e1e65e3925fdbe36265b9438bf"
  license "MIT"

  bottle do
    manifest_sha256 "c749a5991267604a5d30f805916778c9d924b589ad5bdfc75fb7891e8a857ea1"
    sha256 cellar: :any, arm64_golden_gate: "0d1683f3dca4e3db1a986dd9c6ca7fa00e115bb7e0ed04fd68b64f4ec4a66c66"
    sha256 cellar: :any, arm64_tahoe:       "7925f4fa1544de65be467b6c8c69f6f0de5406d52055584ad6664d2c4121af87"
    sha256 cellar: :any, arm64_sequoia:     "f945c2d251d5fc13e1a25f49452e16edfbdf7fe715d8bb33f1ad3ddba1fb9ba9"
    sha256 cellar: :any, arm64_linux:       "2f16d2752e28b3545907397b4d9b92c571cb44e8f62862abb95b823498f26fac"
    sha256 cellar: :any, x86_64_linux:      "8fab8c2b33ca49380861ef73c9f874216c96a26d4ae73e4c1da38e1f52d7f080"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

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
