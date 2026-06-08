class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.14.2.tar.gz"
  sha256 "de48e4cb92bae42164aa91f127f68fbc0032a1d1de632462702450ee0308042c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "09cdf9fce6646bd7274beabc9bf572892b93bb1a36196be81503ca996931bc93"
    sha256 cellar: :any,                 arm64_sequoia: "57cd0f3f14c89b00dfcb49a0a18a2d186f2b78088de199825688592138e7c672"
    sha256 cellar: :any,                 arm64_sonoma:  "c03916750a815d9f3d329f3834d410ab4528a8482479db912f57332e769d9dff"
    sha256 cellar: :any,                 sonoma:        "1a38093ea7fe5b7f8ce377eab550c25f6c6c499439f4548df00caabb74c63560"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfe4ed0f65814ba3a3da9d70d1b1038af89e2f9eddcd19268c8e6edb62125cb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce08827ed367b20e9ed250e555d648d84e396c83310635df06d97f97fdf10c40"
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
