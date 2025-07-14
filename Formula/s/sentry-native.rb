class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.9.1.tar.gz"
  sha256 "28234378f7673e9a88521e5a74d8272df83be87c7b743460a6c88dde21c5f9cd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3c732fe3076055a1d54591b0f99b8004617e6fc1531c558ca9791bcc88ce3a4e"
    sha256 cellar: :any,                 arm64_sonoma:  "294fdfdc007fb3a12ab08d2a5f3793153c8617c175a7a534573d7bf66f40923d"
    sha256 cellar: :any,                 arm64_ventura: "647be17d117dac6b4c9134c1162ea3e2882617206ea7cacab42e8018081cf18c"
    sha256 cellar: :any,                 sonoma:        "9dc606d00db3e9bf857f049488ca76424871b2541f5d5bb3ee5dd63a3ac00961"
    sha256 cellar: :any,                 ventura:       "0a30ba139351038ab1ff54e392fcf96603b1a986924bfea6746b56f61e389688"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98b7eff4a8bae55ecdd13b3fed01cd61ff1f91fe761b0386fca740df993d1c08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38a08f7534e396dc1bb73a688a03f47474bd7be3f4249a8b95d7164805a74ee5"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # No recent tagged releases, use the latest commit
  resource "breakpad" do
    url "https://github.com/getsentry/breakpad.git",
        revision: "7fbf89065fbb0d26526278a5e733270f83993cda"
  end

  # No recent tagged releases, use the latest commit
  resource "crashpad" do
    url "https://github.com/getsentry/crashpad.git",
        revision: "e24b0f9e760e27464fe2ed30fdd7be45a27a67ad"
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
