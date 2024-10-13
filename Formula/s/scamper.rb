class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20240920.tar.gz"
  sha256 "02d242c577e31d61d3babec0a088e997f3c96bcc517f6d2ad35eb41cf1c5f616"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "373b39160403e758b736bf98401888bb54ace1cc5d035dc2000fee11d1c0e882"
    sha256 cellar: :any,                 arm64_sonoma:  "1e328ef13d24e2175f41c48b55a27b9aeac3b2275809991f6282eba1348de7d4"
    sha256 cellar: :any,                 arm64_ventura: "5c79473454e8233309fef004fd2abb899321f10a8b992b62300009c2e9fb6bc6"
    sha256 cellar: :any,                 sonoma:        "73c22f42a95d5f7af8b3b5559667d585b7142a05b6dafcb2d60452bfe9f9d2b3"
    sha256 cellar: :any,                 ventura:       "931e879aa5b992a4c3a9652f68908e5c0746fc273d1cd382c0eab0fbd1394717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34fcd9a3a7fb4841757c4ad019af577ff8934348123c912261a6253f2a924658"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "xz" # for LZMA

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    expected = if OS.mac?
      "dl_bpf_open_dev"
    else
      "scamper_privsep_init"
    end
    assert_match expected, shell_output("#{bin}/scamper -i 127.0.0.1 2>&1", 255)
    assert_match version.to_s, shell_output("#{bin}/scamper -v")
  end
end
