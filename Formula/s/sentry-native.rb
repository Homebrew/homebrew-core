class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.12.2.tar.gz"
  sha256 "e995c8dd3b5150ef306f0697a021688c4392a1e9ad63f0269406a8d471112c39"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6cc0539f150c915516f9ed8c13e330ecc33807e8f507d4698f049d720f4df2b1"
    sha256 cellar: :any,                 arm64_sequoia: "bd7429a7f8818bedfe7375eba3ab0cd3f8ed851f32b9f4cfa607465f5fb6e2a7"
    sha256 cellar: :any,                 arm64_sonoma:  "675c583eb89e8db4be55a4b79f556a5a62ffead10574b77f803f4ee691831501"
    sha256 cellar: :any,                 sonoma:        "6cb44eb59cbddd3c2bde6863fb4d502e5170fe19f375fe76f7152984b9873a4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b5bdf657f6310ca12d3b7e8fc6a442214f76b6553c5143e9fb9c8753ea60bed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ad9684474659566b387187bffa5e3813dd123630d1929b4402d14609e91409b"
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
        revision: "60dd8995c6a8539718c878f9b41063604abe737c"
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
