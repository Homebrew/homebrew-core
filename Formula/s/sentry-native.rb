class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/releases/download/0.17.6/sentry-native.zip"
  sha256 "40b4b70cbada5bfae5b73f8267831dd023ec676d9676fb0d890878f31d2b5055"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0b3969f0cd21cd8415c9474251f59975b693e513397bb5ff1623c507ce9aa837"
    sha256 cellar: :any, arm64_tahoe:       "ea9de36fcf48abffa0cf2f17d549b12417d6b7760437c7749c3e647a651a8bab"
    sha256 cellar: :any, arm64_sequoia:     "4545f8ca83199f65ccf24b295e398b3eed5cc26c22984b6fda94aeda13f1b4e3"
    sha256 cellar: :any, arm64_linux:       "0349ca0be3b4b2497fbb653ed2cf019340117fe5f9e2f63af0366eda1c87bdbb"
    sha256 cellar: :any, x86_64_linux:      "ca26f6412e22b6edd0576b99848054e6f8b4ac356d50d8a38621d125243a3c5f"
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
