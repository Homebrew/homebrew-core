class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.14.0.tar.gz"
  sha256 "e5989a48c0d6e447899c0b42984b8a08ffad4c8e4dbd5eda30d8d79ae6f33cdf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e4b810b8b1692c6b2b88533616fd4dce4399be385b559fda97b779e622cd6956"
    sha256 cellar: :any,                 arm64_sequoia: "daf82c87aeeb923b054a48f361df094313ed43447a74e81639fecfafb3b7943d"
    sha256 cellar: :any,                 arm64_sonoma:  "1476d4bb05f3a5924d4e56e86b316da9efbca2b85e340557defb06fb7e190725"
    sha256 cellar: :any,                 sonoma:        "25d670a9c706170db3a7a147d2075ee42deb9f0aedb80f29f0c76addd8bd6b67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5d30c1e2d30d7ce500837a46bec4553b5e50642958a677dce97b220d285155b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eeec2b0a86dfc599cb6bedad2bcc7f93cfd4dd2bac9a5ef88140f29dd2ee56e4"
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
