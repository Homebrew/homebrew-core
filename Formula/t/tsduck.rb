class Tsduck < Formula
  desc "MPEG Transport Stream Toolkit"
  homepage "https://tsduck.io/"
  url "https://github.com/tsduck/tsduck/archive/refs/tags/v3.43-4549.tar.gz"
  sha256 "a3399661d21e0d965dfef3750d4af7da61eb2924e7b48ee3edaae194ffa5203c"
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
    sha256 cellar: :any,                 arm64_tahoe:   "6df3bda97beca0157e253de2048841ef6d0164bcd624f50e8444e552766b2cc1"
    sha256 cellar: :any,                 arm64_sequoia: "5b7140f45aed01d2b25bb577b21600b64057c41326a604e4f3e816e9d0c9b031"
    sha256 cellar: :any,                 arm64_sonoma:  "b21748e23ee625c44d7fa743c03eb7c61b556d4104191dae75662ad1f22de88e"
    sha256 cellar: :any,                 sonoma:        "2bfd6c803f74c29ae919f147980ae9fa44a830070cb9319ae5f7d5d615db0109"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e422088c607c170a5dcb7d7e1dda9eeacd8507dca9b7f37b33f97d0bff7b437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68e7d58bf0f93d4600bc093b729163245b709edb9bb83282017c718cfb744e3d"
  end

  depends_on "asciidoctor" => :build
  depends_on "dos2unix" => :build
  depends_on "gnu-sed" => :build
  depends_on "grep" => :build
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "bash" => :build
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1599
    depends_on "make" => :build
  end

  # Needs clang 16
  fails_with :clang do
    build 1599
    cause "Requires full C++20 support"
  end

  # Add sys/time.h header
  # PR ref: https://github.com/tsduck/tsduck/pull/1689
  patch do
    url "https://github.com/tsduck/tsduck/commit/c46fd301f31be8c9aa00ce6d6e21c4e4c6bfc1cf.patch?full_index=1"
    sha256 "c20a1989f2fb528c5326e088beac78cae438c9ea00a93c4b6d04400df7b4ff77"
  end

  def install
    if OS.linux?
      ENV["LINUXBREW"] = "true"
      ENV["VATEK_CFLAGS"] = "-I#{Formula["libvatek"].opt_include}/vatek"
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
