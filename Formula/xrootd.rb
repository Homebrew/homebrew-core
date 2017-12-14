class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.8.0/xrootd-4.8.0.tar.gz"
  sha256 "0b59ada295341902ca01e9d23e29780fb8df99a6d2bd1c2d654e9bb70c877ad8"
  head "https://github.com/xrootd/xrootd.git"

  bottle do
    cellar :any
    sha256 "bf60a39b1189ad5217b261c4de2f8388291f099ac947a5b852cca4565ee54bca" => :high_sierra
    sha256 "5a0ae05f121e7335ef070ef233891e841b665791905df36bc2b27c29c10197a4" => :sierra
    sha256 "939ce0f718e05566bde70657c32b303300b4577ff85e4c1b20db70c349d942ed" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
