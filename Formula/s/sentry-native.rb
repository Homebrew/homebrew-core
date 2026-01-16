class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.12.3.tar.gz"
  sha256 "f4a4b419b50bb2d7f85cf5b563c18745e599ddd024129496d2a4bd7f04a92d78"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b5cd020339b03b945ed548335d44ec3a6af206c1d5a42d68247ca1829e5ec7a8"
    sha256 cellar: :any,                 arm64_sequoia: "c891cb56c1777974c3e102014f4db2ead1295caaf6040d0c45d69ce2016b9f4f"
    sha256 cellar: :any,                 arm64_sonoma:  "8922dc345c642fa72d40e420d6e1af1c2b9b7ac5b8f5ef3a815d7029417d9943"
    sha256 cellar: :any,                 sonoma:        "0362a95b31d889aff4fc4b9d4a3603ab6b0bda9311fa7738f4d9c8d7b30f010f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58fef3aa9b490e6f92a61e6864bf5c675d64b647eb3c3db5e0ed3fbff6f8844c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0142186f81b826e4a41cba17487a3a8c950ffd2b8220e7d41757586c5b27e8bf"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # No recent tagged releases, use the latest commit
  resource "breakpad" do
    url "https://github.com/getsentry/breakpad.git",
        revision: "47d70322c848012ed801e36841767d7ffb79412d"
  end

  # No recent tagged releases, use the latest commit
  resource "crashpad" do
    url "https://github.com/getsentry/crashpad.git",
        revision: "63ef3357657ca856d5ff1dae9fee8dc16a425811"
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
