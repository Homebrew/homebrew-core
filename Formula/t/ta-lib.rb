class TaLib < Formula
  desc "Tools for market analysis"
  homepage "https://ta-lib.org/"
  url "https://github.com/ta-lib/ta-lib/releases/download/v0.8.3/ta-lib-0.8.3-src.tar.gz"
  sha256 "28b1179b178a0db15f3dad0d846ef77f18eb06db5dfc5b5a8ca153a9ea5d84e6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9a2e16d1c396f11e40ae72ce31e563352d0982f1fa573dcd8ba94cf94a711218"
    sha256 cellar: :any, arm64_tahoe:       "da7b5a46fc40202dc7ed8eb5f051a60a69b976d9a236850bea7a88cff1b88c0b"
    sha256 cellar: :any, arm64_sequoia:     "d747d9fb966ef2105c4bf74c7e0ae8e2197dc5d9e0821173d03bc0933af6f623"
    sha256 cellar: :any, arm64_linux:       "f077a20a046456125e06614e069c213d87bf9497bdd1920531b8ac87e6f2e91d"
    sha256 cellar: :any, x86_64_linux:      "b15a93e0d67c3c8270f46f3101c853cf9a4e210a22491de4970cad4db1ec449c"
  end

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    ENV.deparallelize
    # Call autoreconf on macOS to fix -flat_namespace usage
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?
    system "./configure", *std_configure_args
    system "make", "install"
    bin.install "src/tools/ta_regtest/.libs/ta_regtest"
  end

  test do
    system bin/"ta_regtest"
  end
end
