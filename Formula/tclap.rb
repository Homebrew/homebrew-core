class Tclap < Formula
  desc "Templatized C++ command-line parser library"
  homepage "https://tclap.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tclap/tclap-1.2.2.tar.gz"
  sha256 "f5013be7fcaafc69ba0ce2d1710f693f61e9c336b6292ae4f57554f59fde5837"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d99ff85d8e6543174db3f87f900d3dc7c8ba6ad9983958ca30e162c122dad50" => :high_sierra
    sha256 "5f1ea1598586b9dfaa54d0362eb21cd2c9210006f46a7568eca09ded1c507dfa" => :sierra
    sha256 "71be8c4b552ec527decd02a459139353ca738b90d3971a560276a74694511caf" => :el_capitan
    sha256 "af4d9a41dbfbccda4f583e9dff77a8f93978a07f624df7a1f9ed30662c006274" => :yosemite
    sha256 "b93a8106cce72de8055b375519b93b00977e2368b758ccf3481497d075ec6738" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    # Installer scripts have problems with parallel make
    ENV.deparallelize
    system "make", "install"
  end
end
