class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/releases/download/0.17.4/sentry-native.zip"
  sha256 "804811557b5d42ddd51cb1241bf851964d75547a4eb7b5ad97b73a4de965ab25"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bcbb1a324999408b9d69c270a6c7f0363be739c7e3eb880caaf9080fb1823664"
    sha256 cellar: :any, arm64_tahoe:       "f59e53728b3b56e9ae5ba883c48a7d7956c136342714a8cfe0a955f6e427cc0b"
    sha256 cellar: :any, arm64_sequoia:     "67786eb922b38bddc02c491c4d42c96e8e173c856bb55effd0987fad2e5ae506"
    sha256 cellar: :any, arm64_linux:       "2c0a587e2b4f1ea31062156eb2e4032404dc229cea6b28c2ca77ad33725a8e25"
    sha256 cellar: :any, x86_64_linux:      "ddd19f7b7b3cb24baa6ec4b404916ef42221858c716197e13fdfff626436c462"
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
