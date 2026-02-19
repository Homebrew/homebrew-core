class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.12.8.tar.gz"
  sha256 "a9c065aac52eaf4e7fc670c136691432493579f7d41b1e7ab23e2a4df8ce9cd2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d49be363868222bd4b4e01504d1e478882ddf70585af80bf0475d39421af5602"
    sha256 cellar: :any,                 arm64_sequoia: "06f481c1fa47675b5fafe78e6934f76dc9fa6362855885569455f2607dfc270f"
    sha256 cellar: :any,                 arm64_sonoma:  "8748ee3eae1dba301a8132a5c192d4805295fa77c8308b028ac10b30b05ed055"
    sha256 cellar: :any,                 sonoma:        "82bcabd0965d95b817423e9b3217d66afaff0979a341558b900000f7c3311e20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21cf2c9a72310e2c8d3af0977174c802d0a4716aac9362c0f546c91804cfedfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faee6978b5895c19d647342c5e2b612d5f39a0fbcdc938dca3a7364d97d69426"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # No recent tagged releases, use the latest commit
  resource "breakpad" do
    url "https://github.com/getsentry/breakpad.git",
        revision: "47d70322c848012ed801e36841767d7ffb79412d"
  end

  # No recent tagged releases, use the latest commit
  resource "crashpad" do
    url "https://github.com/getsentry/crashpad.git",
        revision: "eb5fa6e8576e79113b21296bd6af7e2a542839db"
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
