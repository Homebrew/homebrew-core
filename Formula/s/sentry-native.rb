class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.12.1.tar.gz"
  sha256 "2bf5c810b9a8f0a58e0ce489704750c6c49d252338388f7e78ef0698d2b2613b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c37fab17d682e4c532156132c29edd852d893d46a3ed97fd7be62423b98a78ff"
    sha256 cellar: :any,                 arm64_sequoia: "c48150389636213308ebb2e59dbc2575047b14215439a46c88712a3f8b998fb4"
    sha256 cellar: :any,                 arm64_sonoma:  "7cc1e23e7a24d32112cd655224e385bf2b4730728e7022294601b1175224bb4e"
    sha256 cellar: :any,                 sonoma:        "a9cfb86925a1f325f7eb842fb137db8b40a911a86ba2b3c8565763a06f35630c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ecdfcbf2c153372012d5cd2594317773d8aae39d9112fba1bc9b6ad2029acbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a15c2bbc8d94995ccafbabedd4dcea61698895736acc3aab793cd2e9c59300ba"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # No recent tagged releases, use the latest commit
  resource "breakpad" do
    url "https://github.com/getsentry/breakpad.git",
        revision: "25b6b727af49fa383161e7dba4a82ab0661b69b8"
  end

  # No recent tagged releases, use the latest commit
  resource "crashpad" do
    url "https://github.com/getsentry/crashpad.git",
        revision: "d8990d2f686b8827a21532748c6c42add21c21ea"
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
