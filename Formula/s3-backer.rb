class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://archie-public.s3.amazonaws.com/s3backer/s3backer-1.5.4.tar.gz"
  sha256 "7e73bb8378a4ccf7b1904a078fbc4731b07138951cbe1c20ce7aa0eb3e8da0d0"
  license "GPL-2.0"

  livecheck do
    url "https://build.opensuse.org/package/view_file/openSUSE:Factory/s3backer/s3backer.spec"
    regex(/Version:\s+v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    cellar :any
    sha256 "81a2723bf9153259c910e49858bb49bd1aa26ef8a23e05a0ed7a8b01c6e8a032" => :catalina
    sha256 "56ce3b86f53c7712f6e60f5059e920ef5237f335a19443ff81fe1a2a3a40b583" => :mojave
    sha256 "f1544f1d212b7bf4fe34cea698a3f8a3a0fef49f9590777ab81d1eb56b71d40f" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
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
