class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.11.1.tar.gz"
  sha256 "f2c2fec6ea8ef2658fb4cfa64ea6180eee96873647cfc33c5aad54cf5d0ed0ee"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7cfdf050bb62f2317b5781e1db7ab0c69f37b03d462ee942eaf573dc3452a3d0"
    sha256 cellar: :any,                 arm64_sequoia: "0789e4d046cdc35f9e47568e30b5a9ce0928e3dcab88b4bdfb20d88ab163c574"
    sha256 cellar: :any,                 arm64_sonoma:  "653b1e36fe90f0f9789d9294267bcf564e56eaa8014237d2f9faa3f1bcabd4e7"
    sha256 cellar: :any,                 sonoma:        "dabe0250830ed3c660fc73b0e8848839f7e079ba4b1d83b615909f053f8b0b20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b82454a58b21c0214b8e2ad9014a40a374db99b0b81b7368d82bd1ea486f9d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50e70b03b8ee46af725787ef0d9419f83a0f9932981124b0ab2ad8c78e71a7c2"
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
