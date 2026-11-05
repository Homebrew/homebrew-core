class Zlib < Formula
  desc "General-purpose lossless data-compression library"
  homepage "https://zlib.net/"
  url "https://zlib.net/zlib-1.4.tar.gz"
  mirror "https://github.com/madler/zlib/releases/download/v1.4/zlib-1.4.tar.gz"
  sha256 "02dd159783677a749c04adbdd02b55b8a2bcc7e054f51b76b549199a916ad584"
  license "Zlib"
  compatibility_version 1
  head "https://github.com/madler/zlib.git", branch: "develop"

  livecheck do
    url :homepage
    regex(/href=.*?zlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4fce88358803cd0dfdcc14e2afaf932af2a6a63927c197029e36bf13a072b002"
    sha256 cellar: :any, arm64_tahoe:       "af30c0eda23564e812e00202ef7ae256584016dcbb0b88afb1120e768224de87"
    sha256 cellar: :any, arm64_sequoia:     "89a6f0a9841c9d3b38fd8733bd905fe2f2b218f803c77c7043a6116dd9f3b037"
    sha256 cellar: :any, arm64_linux:       "49e4dcb67cdd2c48deebe117d4cd1507641535d94f309e268b9e0e2ae9bf7a04"
    sha256 cellar: :any, x86_64_linux:      "b3eb31f74b7bdd08a084eef995399d27553b97f9639aa59eb525c402db67becc"
  end

  keg_only :provided_by_macos

  on_linux do
    keg_only "it conflicts with zlib-ng-compat"
  end

  # https://zlib.net/zlib_how.html
  resource "zpipe.c", :test do
    url "https://raw.githubusercontent.com/madler/zlib/99623ef7097352da7993ba614161fd6a311e046e/examples/zpipe.c"
    sha256 "e79717cefd20043fb78d730fd3b9d9cdf8f4642307fc001879dc82ddb468509f"
  end

  # `test do` block downloads a test fixture resource
  allow_network_access! :test

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Avoid rebuilds of dependents that hardcode this path.
    inreplace lib/"pkgconfig/zlib.pc", prefix, opt_prefix
  end

  test do
    testpath.install resource("zpipe.c")
    system ENV.cc, "zpipe.c", "-I#{include}", "-L#{lib}", "-lz", "-o", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", text, 0)
    assert_equal text, pipe_output("./zpipe -d", compressed, 0)
  end
end
