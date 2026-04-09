class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.13.5.tar.gz"
  sha256 "590dc25f6b5049cdcd60a635ec900f11c7df9aa6f4d0def9bd732f28e99901b3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "282583fec14faa3642a9c907ca51bf42c7be9c40ccc893f553ce13c62fea5e15"
    sha256 cellar: :any,                 arm64_sequoia: "2901ad8912f6e9781163018f517db6ed1139a8e08fc1fb463c27daa2a0a05126"
    sha256 cellar: :any,                 arm64_sonoma:  "a07a7366be848f83730280984eac58861874aca8af31a7f34b1f63780d797dee"
    sha256 cellar: :any,                 sonoma:        "378e45280426694586d903d16cf43b1aaeb638dbc1518d165f0a48b1fbb8f4a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2afd54c088bc533348292c64e4ad89bbe66198431b6e8c5e0272301fefcc8d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be3f62d1fb169fe0db208ed45d6b465d584e0774a1481500f8acf70c5acae180"
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
    url "https://github.com/getsentry/crashpad/archive/eb5fa6e8576e79113b21296bd6af7e2a542839db.tar.gz"
    sha256 "2ca344714dd624a5f91e72c2f56a97f33d62e602522be184d55a13fed9381c36"
  end

  resource "crashpad/third_party/mini_chromium/mini_chromium" do
    url "https://github.com/getsentry/mini_chromium/archive/5d060033dbe1595f612a2f506b7988c8d513d32e.tar.gz"
    sha256 "72d7264f6e3b4ef89d16ef8d32bfc0b3b99b19a539a9bedd514191efeed658b4"
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
