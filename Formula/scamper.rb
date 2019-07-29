class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/tools/measurement/scamper/"
  url "https://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20181219.tar.gz"
  sha256 "fc80a079cd4db85860cf9b11118747bdbd2e33365e9b3456f7cf4403cc8241bc"

  bottle do
    cellar :any
    sha256 "af942b4eb24054c5d8dda62a1282f8c704d2e3b27c3d0ce4593dab06debce3df" => :mojave
    sha256 "382772d3cda9d7e0af62b0dc1567a55065db9c830aa7f2c3f2eaaea3e7687dea" => :high_sierra
    sha256 "d8f6a50e29fb475aa198250815a03aa8e27f6381cd185d72038ee2cff07c6f45" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
