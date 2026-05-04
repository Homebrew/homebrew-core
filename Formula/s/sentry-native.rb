class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.14.0.tar.gz"
  sha256 "e5989a48c0d6e447899c0b42984b8a08ffad4c8e4dbd5eda30d8d79ae6f33cdf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "62002ae41ff2a9655b1326d8f2d8ce7fa7a0cc347612ca04b7439a9ec4e2cfa5"
    sha256 cellar: :any,                 arm64_sequoia: "3c67d4783c7d1311299a1718cf2895340b4a14a902e3474d81d949a05bc73f42"
    sha256 cellar: :any,                 arm64_sonoma:  "c0a4ba534aed7bed3747c28bb1dd07ed12fedae80549b1bac7b334f9a3a86256"
    sha256 cellar: :any,                 sonoma:        "fc3da2564de711e845cb9ca66f2396003f60a21dd4b5a16d4baaf83d92747072"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06dcfc68f277fd1f275b563d2e20a2d800313fe9fe054bad0aec9ec4bde56393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "765b5ab8146b7c8d9906da869f6b81fcc7ea82675e8a0eda7a1d53dd7db5d7b7"
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
    url "https://github.com/getsentry/crashpad/archive/17b7aca1634f1a91018f1bba13f7941a2892e864.tar.gz"
    sha256 "721d952b20da8d79a0306f7db9ac4166d34db4b028bcda665ab19b8582ec4b1b"
  end

  resource "crashpad/third_party/mini_chromium/mini_chromium" do
    url "https://github.com/getsentry/mini_chromium/archive/64339ac9468a8c3af236ca9186b42a33354455b9.tar.gz"
    sha256 "f3f5b619705ce0aa139f13d654950ba4fdc5a4616dda74efec91e2f5e04b378e"
  end

  resource "crashpad/third_party/lss/lss" do
    url "https://chromium.googlesource.com/linux-syscall-support.git",
        revision: "9719c1e1e676814c456b55f5f070eabad6709d31"
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
