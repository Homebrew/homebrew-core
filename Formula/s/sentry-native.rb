class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.10.1.tar.gz"
  sha256 "29937d907ec9f8acc6531e64c2dc9bacb4a6cd32c65f5c327574474c934d93f5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f3ac84e2bdd14807084d3c7de31e005f1351e0cbf1d1f2ef8e6ec04b85a6b118"
    sha256 cellar: :any,                 arm64_sequoia: "eb797ea2740deae9aa4001c36300c678a1cb4d9e3492041be53c5b795f2671ac"
    sha256 cellar: :any,                 arm64_sonoma:  "25eef1afe842a39102514b4c8dda27f79866787878589b7f62b90a0ebb7e5539"
    sha256 cellar: :any,                 arm64_ventura: "062f0bf0ffec81ddb794992cfea7e15c26e7151e10bd3985e627ba708201d992"
    sha256 cellar: :any,                 sonoma:        "a3ca02b904fd4b00a8a14dfead48c7df3f27ad26a5cfe49c17076286697769e3"
    sha256 cellar: :any,                 ventura:       "a54dd2efbbd5839aca6b695458523b7c3c9f3f4addf32514f6a055b591dc931f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eece1736d26dd9d0137046f0aeef85f047b0fe55cebd9a5ffda5482a787742f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53b08f9cbfc327891b1e57e36600b1e668433ae1b7abb9b37a467f05fdb3f171"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # No recent tagged releases, use the latest commit
  resource "breakpad" do
    url "https://github.com/getsentry/breakpad.git",
        revision: "9b606719129be728005e3c295d4c74bd1a15c0ed"
  end

  # No recent tagged releases, use the latest commit
  resource "crashpad" do
    url "https://github.com/getsentry/crashpad.git",
        revision: "137d0f478391c0df8f80072db2548a7ba7e4c13f"
  end

  # No recent tagged releases, use the latest commit
  resource "libunwindstack-ndk" do
    url "https://github.com/getsentry/libunwindstack-ndk.git",
        revision: "284202fb1e42dbeba6598e26ced2e1ec404eecd1"
  end

  resource "third-party/lss" do
    url "https://chromium.googlesource.com/linux-syscall-support.git",
        tag:      "v2024.02.01",
        revision: "ed31caa60f20a4f6569883b2d752ef7522de51e0"
  end

  def install
    resources.each { |r| r.stage buildpath/"external"/r.name }
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
