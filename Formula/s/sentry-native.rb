class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/releases/download/0.17.6/sentry-native.zip"
  sha256 "40b4b70cbada5bfae5b73f8267831dd023ec676d9676fb0d890878f31d2b5055"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8357a68aef226c674b5f868cc06e9cc8a7bd91eed9512a8edf8cc35e0755f516"
    sha256 cellar: :any, arm64_tahoe:       "68c403267c3f0475498f4dd3631bdea55fed0525ab784ccaa3f84520606fe513"
    sha256 cellar: :any, arm64_sequoia:     "1c75cbd1eca8f5dd91fb1252ca88d41447eed1e0703289c68985ac0391d6aba2"
    sha256 cellar: :any, arm64_linux:       "9fc53889e9e63757f64a60b871382117a4ba9626dcc7508ded4861931f8580f5"
    sha256 cellar: :any, x86_64_linux:      "4454f41a4916006e66aa41771d2c9d7926aa81308db00721637a14fedef9ace1"
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
