class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.8.3.tar.gz"
  sha256 "aa35384cbcac5e91249a1101ed16e32e7da5ed387595b9fc7d914ae58f0eaac5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b868fe4c5e7f8e34472adc7f8b25b403d21a1334af7dc431846cb2707c081481"
    sha256 cellar: :any,                 arm64_sonoma:  "e456c2f6027015f80e1ffec75953ac133631c986e1b48d580e0f0fc1e5e2ff1b"
    sha256 cellar: :any,                 arm64_ventura: "9d73d3838dfa72ae73adfd1af5c7bf727a608d321e25065a852947b043b0c7c9"
    sha256 cellar: :any,                 sonoma:        "6e29ba37e05a10f681549496c00cb033be9bc7f55e5d85f6278154f5e6b6d9f4"
    sha256 cellar: :any,                 ventura:       "4e6dcdd45dd9240816a5f8cae76e87092d4b9f27d862169f11a57eff83ad00bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f91ba04e2014681376b7910ad9d379e86b4e087cd6751e5adc247e3b2260e169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b7f7343375e4885cfea46a9811fffd93c7c28b3de3577cf6a13a6cc06323ff4"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # No recent tagged releases, use the latest commit
  resource "breakpad" do
    url "https://github.com/getsentry/breakpad.git",
        revision: "ecff426597666af4231da8505a85a61169c5ab04"
  end

  # No recent tagged releases, use the latest commit
  resource "crashpad" do
    url "https://github.com/getsentry/crashpad.git",
        revision: "2d97a484bb628b05a46203e4a05c6c827796e5cd"
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
