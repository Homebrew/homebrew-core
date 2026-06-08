class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/refs/tags/v3.44-4676.tar.gz"
  sha256 "22a6be2fdaa1714200c5ce0640dba551a9be9e2b2b8fb53067224ebf80c7c30e"
  license "BSD-2-Clause"
  head "https://github.com/tsduck/tsduck.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e6f329d4df878e99a4d5bdfa13adc4f795796dd5249487863f0d9face40ee5cb"
    sha256 cellar: :any,                 arm64_sequoia: "d38e29c129e02108e06fc9382e1fd973b044e534de0cbc25e8097303c49cbcce"
    sha256 cellar: :any,                 arm64_sonoma:  "e18ff93ca5bf400b6e5eaa8860d157f3f4ab2ac627dfa4c7e378ec89ec35b002"
    sha256 cellar: :any,                 sonoma:        "4e60e02dd989b0bab97de96497b96fdb901e7e4145fc94e88742460e80530ae3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07084f5e111e21e9af0747f45826adf34a3fcf53a6d2fae6ce2b35de377dc441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3cdb8420391994de64f82e088abc900cce361418a70d44a4e84311351d99b81"
  end

  depends_on "asciidoctor" => :build
  depends_on "dos2unix" => :build
  depends_on "openjdk" => :build
  depends_on "qpdf" => :build
  depends_on "librist"
  depends_on "libvatek"
  depends_on "openssl@3"
  depends_on "srt"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "pcsc-lite"

  on_macos do
    depends_on "gnu-sed" => :build
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1599
    depends_on "make" => :build # needs make 4+
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Needs clang 16
  fails_with :clang do
    build 1599
    cause "Requires full C++20 support"
  end

  def install
    if OS.linux?
      ENV["LINUXBREW"] = "true"
      ENV["VATEK_CFLAGS"] = "-I#{Formula["libvatek"].opt_include}/vatek"
    else
      ENV["LDFLAGS_EXTRA"] = "-Wl,-rpath,#{rpath(source: lib/"tsduck")}"
    end
    system "gmake", "NOGITHUB=1", "NOTEST=1"
    ENV.deparallelize
    system "gmake", "NOGITHUB=1", "NOTEST=1", "install", "SYSPREFIX=#{prefix}"
  end

  test do
    assert_match "TSDuck - The MPEG Transport Stream Toolkit", shell_output("#{bin}/tsp --version 2>&1")
    input = shell_output("#{bin}/tsp --list=input 2>&1")
    %w[craft file hls http srt rist].each do |str|
      assert_match "#{str}:", input
    end
    output = shell_output("#{bin}/tsp --list=output 2>&1")
    %w[ip file hls srt rist].each do |str|
      assert_match "#{str}:", output
    end
    packet = shell_output("#{bin}/tsp --list=packet 2>&1")
    %w[fork tables analyze sdt timeshift nitscan].each do |str|
      assert_match "#{str}:", packet
    end
  end
end
