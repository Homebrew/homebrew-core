class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/releases/download/0.16.8/sentry-native.zip"
  sha256 "ad14e09822464c91f7722ea299f69aef29eb61b5b71e15f5fb557bc25359cd48"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9e08549a3f76278ce298f20f2562d23e583af2ad790e1941f51e635e1878e649"
    sha256 cellar: :any, arm64_tahoe:       "324954ca4f925b8ddd45e38901d3ae6232d19477e7877c2ab2c6f40723bf6471"
    sha256 cellar: :any, arm64_sequoia:     "42bca5f6f352de19469a125263e4d134845e56a6253fb9da349c3a9dc4fef498"
    sha256 cellar: :any, arm64_linux:       "78f3128920b22ee1414b6d15bfb93501e1c6d941a57a6edad64d87970a8e854e"
    sha256 cellar: :any, x86_64_linux:      "7ed7c680e7435f152863840f7b7012d29d23762aaf10698203249aadaa3487b8"
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
