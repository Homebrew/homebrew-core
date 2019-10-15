class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://archie-public.s3.amazonaws.com/s3backer/s3backer-1.5.2.tar.gz"
  sha256 "e6dfbd15bddbef9bbb6d014377d61a1c3561b4831a85c92772bd8ab0efd55ce9"
  revision 1

  bottle do
    cellar :any
    sha256 "315152aa2fbafaf7308db5e4f2a0a2e3c42a8ef96a219f134b35d8474dc71bf8" => :catalina
    sha256 "c84fa0694ca7dcef09900cebdfe731fd8e4e0706537066cbc88ec5f278533596" => :mojave
    sha256 "78fc6bc72e337c428ef786756fe727d6fc9433c31e8109d7b63230de27f242e1" => :high_sierra
    sha256 "cd068954d59ab5702b582f745e42785480cb36fb52423a6526b5112ba19c0bd1" => :sierra
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
