class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.14.1.tar.gz"
  sha256 "71dabc4d0d5985fecedd64eeb808a77d4c67bd48926b6e9b65efdf9038000bcc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8460aebdc78b85017e66ee3cc3776a2aee6054ee1a3bf1731452bd59fbdfa80e"
    sha256 cellar: :any,                 arm64_sequoia: "54833fabb138b8930e2cdf8064586a7d6d21842d73d46efb1c7f9bbb876a6887"
    sha256 cellar: :any,                 arm64_sonoma:  "6f3ef1ee4f26c3eab88331c459af9e2f68ed16108fe6d186b14b0b9d14d0ef34"
    sha256 cellar: :any,                 sonoma:        "21f72a3be08ffd8bf08433c41d19cdae5acb8f2f06c89ace777e4785b7859b32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "137eeac226c9ca016eef10f7eefba62ca4d748af66f8d5b5352d024f98570a86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38f33f1efa67c45a3b7891ed749538b2803985dfd9f718f7b416dfbdc175cc89"
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
    url "https://github.com/getsentry/crashpad/archive/ff141a8c0cc852f9c3d42e13bd9ada551351bc21.tar.gz"
    sha256 "007b7d57e8dbb8665ddc524350f1c50ea646dcdc55b6278bb6a1a18e206754db"
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
