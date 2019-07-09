class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://archie-public.s3.amazonaws.com/s3backer/s3backer-1.5.2.tar.gz"
  sha256 "e6dfbd15bddbef9bbb6d014377d61a1c3561b4831a85c92772bd8ab0efd55ce9"

  bottle do
    cellar :any
    sha256 "d0d604e024aaa423ee691cf6fa22aa572b1186c7a04f0c1bb11840a49c2394a0" => :mojave
    sha256 "51bef60c821f0f80798d08cdcf4b373310342614dc905b93f4a95ffe0fc7aa1a" => :high_sierra
    sha256 "22418cfc8590356bd8cf0a7f393f91e4af35496195bf4058ffac6e858b6ae660" => :sierra
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
