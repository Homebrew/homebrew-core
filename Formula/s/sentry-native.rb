class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.13.6.tar.gz"
  sha256 "7719edaa3af9029583e0a7326aa4699eee45d9fbfd7b0441db27262c3d24e915"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "287edf3b934024d73b105d77c159932be38a2860532a5e18f775c2f3d6a36419"
    sha256 cellar: :any,                 arm64_sequoia: "8712aab4ec14eed97b689c276fa9dab82cddd7cd85508812d3ef140b28062c77"
    sha256 cellar: :any,                 arm64_sonoma:  "8d13d4894522eae9d36b7df6d4c9e5106a39f925bef96f322296d5f95b798629"
    sha256 cellar: :any,                 sonoma:        "2075e01155e716dcb2b6581b73c0ac92d272872daa37e4136b944c974b3c9524"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7f1f83e3b077e001173411390f09c024735d4f85b9b87346279223f98a6fc40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b214beafab8786bcf044f3e1a6e547843a2ff1e0ad24683165a86f782a182027"
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
    url "https://github.com/getsentry/crashpad/archive/e5040b878718f5c004d0ecfe1747642c72ddcd39.tar.gz"
    sha256 "42dbdb932d76df42e48a970f6554744d36e479fe4675bf3b828557f06275a4af"
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
