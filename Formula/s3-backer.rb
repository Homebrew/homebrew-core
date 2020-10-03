class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://archie-public.s3.amazonaws.com/s3backer/s3backer-1.5.5.tar.gz"
  sha256 "060cccee550ce25fc3033a48f39f95a1f071d738b859ba6775bcd819ab32877b"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://build.opensuse.org/package/view_file/openSUSE:Factory/s3backer/s3backer.spec"
    regex(/Version:\s+v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    cellar :any
    sha256 "be91809580fe517084c4836133a713b600436cd1b98db4bf2e2822e3eaabf319" => :catalina
    sha256 "4c9a8dc97cac31a5debaa7c37c102cd0891c010033f51cbb028a00a82822d56c" => :mojave
    sha256 "b0aa731385f917c7dee54d2d9649760a39374b5c898dbf24f2562e6d61878e36" => :high_sierra
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
