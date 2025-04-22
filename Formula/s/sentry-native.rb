class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.8.4.tar.gz"
  sha256 "9dd82daea1c51c2316c49e9e4737ab4c32a79470f5567b93115bb3a0fde4b93f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "660abb347ab20a340bcadf24c0fa824da82e31736a6f8acf8794246b9ccdb4a3"
    sha256 cellar: :any,                 arm64_sonoma:  "789d7be4e53003553ae97314e5aa6b089b4942c666c7887071f11de2737e87d4"
    sha256 cellar: :any,                 arm64_ventura: "4882f061d1617784f6d79f0427134d8c24cd753b10939d7bbb8050d3c1fec0ea"
    sha256 cellar: :any,                 sonoma:        "9f9578a0e89df2aff0e0bc464cbdc94e214c754c80698c9f6672e6ca1e5cce23"
    sha256 cellar: :any,                 ventura:       "321779ce15d4023a5a02f6f0cfad4770ae3780eb9e81555867eb1550fbd4f990"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43e174d2d052d20953bc29c177f60fceba3c83c9569a8ba95afe96b973e3edd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fb98a486f1f22731d5144f1cca2c83e36b7eedd7d6ce7b4036e92369e2b877c"
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
