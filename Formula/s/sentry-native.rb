class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.8.5.tar.gz"
  sha256 "3fb8f15ae1e8e6dbe831711dbdbb4245a7936f25be1b416acfb6d0581875461e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c3efa2cd40cef7ba25c2f1b24e24986d17725442f16b596cc901913279133f44"
    sha256 cellar: :any,                 arm64_sonoma:  "3a3ae596edf78d565a9a12f0cf90fc6b1d11ce9e68f515e9b61e2873b818c0c4"
    sha256 cellar: :any,                 arm64_ventura: "390cb9399ab622c44c735996fca5f1b053a4b562691916e0c56079037901b785"
    sha256 cellar: :any,                 sonoma:        "28c7116f6c096c15321e0143f4e4cf26b6c361572ae028feab1071aa29b32db1"
    sha256 cellar: :any,                 ventura:       "16ca56b23013df1a8b93eca50d4590ab080b8f15b490ddadd1b79c7504122376"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab1ea85123a656a304851e797ad6e2f3737ee2e67549c5989cd2b016ee580fe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73a1db60efd90fb8457414f61ad8ce67a9aadcbd44190778ad191478291b4d4d"
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
        revision: "a17b30d42ec667c92a99285429e4edf2f7196698"
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
