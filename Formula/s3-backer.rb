class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://s3.amazonaws.com/archie-public/s3backer/s3backer-1.4.4.tar.gz"
  sha256 "7efa9347490e04bc22b4e62bed36864be1ba31bf8558d598cab57ef5096f2c02"

  bottle do
    cellar :any
    sha256 "5dfb9e4fbe94945131d6cbedb34cfdffd3b6580371d0b3bd03b0cac3d1d3f933" => :high_sierra
    sha256 "64df94342e386fa4163eba7f44fb3fa8104ae702ef4649e72530ec0a01a67221" => :sierra
    sha256 "96f82aa40f55286359f3a5c4866eb84a15491b979fc78788eb16cf82bd89947d" => :el_capitan
    sha256 "33fbbf30c5ce36a3d522e55df99b3fa15c2494b1f3d835ae267e44b77c033827" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on :osxfuse

  def install
    inreplace "configure", "-lfuse", "-losxfuse"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"s3backer", "--version"
  end
end
