class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.13.3.tar.gz"
  sha256 "9c830c208fe4d0972ac32b347de0f3aad97c0dce4c0ae8a9e1453850dfd0a9be"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e6d9d8737ed055da24eeb64c7679d673054f14898c0179e8d6ad4771c4ac574a"
    sha256 cellar: :any,                 arm64_sequoia: "a86bfddb6738ce282663fd49e5c149f0ffeac570e7d3c9c9090dbb9ba6a985fd"
    sha256 cellar: :any,                 arm64_sonoma:  "82de8d95e0e998e89edbc0e30a8a9081c2ea929fa40aa43c1e47cf3600d925aa"
    sha256 cellar: :any,                 sonoma:        "a24eb47a612a3195fe4561eb6ec64750201194518f706dc188a98bc5695dbcc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a98aba820011761bfb5da67319efa036034229f46141aaa0fec8851d1d051fc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b845b35d28d72196b9bdf4ebef432488998c1bcd1500f85567b9473c45ec86d7"
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
    url "https://github.com/getsentry/crashpad.git",
        revision: "eb5fa6e8576e79113b21296bd6af7e2a542839db"
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
