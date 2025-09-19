class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.11.0.tar.gz"
  sha256 "8bdbd8c27bfad2f7be53dd852d78298d22516df715ff55b94c7e3c3cc57c0945"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fdad80ea5eef4ecc58ad9a710144ab8662db8b9f1750777714ce2ff7c7f97d50"
    sha256 cellar: :any,                 arm64_sequoia: "ebc715cbb13857702c912ef88eac1be4fe75e93571c3903b3f534d4b49d4721c"
    sha256 cellar: :any,                 arm64_sonoma:  "cbdc30c6aa713aecebdd1ca60af106c10dabe2f62ab142dac4beaa051e851a71"
    sha256 cellar: :any,                 sonoma:        "f0c99237d815bd57261331a33b76eb16ae384ac66d79a58d9ce38377c955c008"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6532762615a0997fdafaa1f75ade2e0bf189370dcd2f39e44a4829987ecc3526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecc1fb3036a560ba2e6637ff695ef873d68d6a2e7529b53a6a920b21dedd1301"
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
        revision: "79a91fe62324c9c17c8ec1b8508778228ba955a7"
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
