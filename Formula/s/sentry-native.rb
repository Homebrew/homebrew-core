class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://github.com/getsentry/sentry-native/archive/refs/tags/0.13.7.tar.gz"
  sha256 "3aacac7feb890356a6fc9a0c8c91b01281842a739585da77375ff36fe7f5be88"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "081357a0c87ee9c16d1493d28f36d7d8b87432b07697aa8bef36161b4a3aba1c"
    sha256 cellar: :any,                 arm64_sequoia: "84ab26c17b0ffc018febff3b5be285fcc1194fa2927020dbe8bef8310635f944"
    sha256 cellar: :any,                 arm64_sonoma:  "cc5eca0b5462154571643f0e713206c9457afe3ec37fa4767eace7276cb42c31"
    sha256 cellar: :any,                 sonoma:        "deafad2d60f27277f56025434f9880d13ad013190faeac6627226eacd007a2e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f399622e1781f751d243c96d18df9bb9408fc941c18f9a6e60e10146c7ae481a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7672617cbcdb6820c87cbd77d486b49f9ed74d8e06548ad2a707cf23c86cdb1"
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
