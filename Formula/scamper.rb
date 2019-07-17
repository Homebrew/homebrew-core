class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/tools/measurement/scamper/"
  url "https://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20181219.tar.gz"
  sha256 "fc80a079cd4db85860cf9b11118747bdbd2e33365e9b3456f7cf4403cc8241bc"

  bottle do
    cellar :any
    sha256 "cab67481dc39c238684cc768012596d086d03594c88423cc4bf027e878a6e98f" => :mojave
    sha256 "8eebcd5d3451744d3020a8925c49988271e8c96f1ade51692362eb0f401fccc7" => :high_sierra
    sha256 "5c0144da8cbe504095f8613d64134dabb97a1a1478ba1104519ab9f77c0fa725" => :sierra
    sha256 "49389540e24b1bb0a606569a1c3cda007cc86e7a1abda920089a326f35ce5d0f" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
