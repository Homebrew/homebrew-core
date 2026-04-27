class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.13.8.tar.gz"
  sha256 "8f6d2f4ca171f446eaf16d71c2f06b53fd5568e7b2117c635e4b70afcd81a874"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ea1fe4a6d30d5e85b1142d5be1f9468ca2b5257b079ba9106eef7b3b25736284"
    sha256 cellar: :any,                 arm64_sequoia: "73f24a065954f2ede2b52ec32518427fba066f416543b6eb70e0e85852a85759"
    sha256 cellar: :any,                 arm64_sonoma:  "dcb114f46f38f92ba5e49bc8d1c19fed62d04be112b81f300dd9f7d48394f193"
    sha256 cellar: :any,                 sonoma:        "9c3df624b361a2e0c9f222bb1855872aaf3bbaed9f3d55c2347ac79327866bdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88609a6a5dab19f01ae09c63c4e89bb4730786d6a81297c4b31f3911296a9699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9554c32a53a4466ccf352e46583421dd425353520003134e4f1a1e426a123b6"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # No recent tagged releases, use the latest commit
  resource "breakpad" do
    url "https://github.com/getsentry/breakpad.git",
        revision: "25b6b727af49fa383161e7dba4a82ab0661b69b8"
  end

  # No recent tagged releases, use the latest commit
  resource "crashpad" do
    url "https://github.com/getsentry/crashpad/archive/38617eb5a0799acade5dc4312f206e0e43642566.tar.gz"
    sha256 "88cec93282d0f96ac249750cbd34dbc002ec514633ae13a05bf27bd275fb14db"
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
