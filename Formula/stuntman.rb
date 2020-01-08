class Stuntman < Formula
  desc "Implementation of the STUN protocol"
  homepage "http://www.stunprotocol.org/"
  url "http://www.stunprotocol.org/stunserver-1.2.15.tgz"
  sha256 "321f796a7cd4e4e56a0d344a53a6a96d9731df5966816e9b46f3aa6dcc26210f"
  revision 1
  head "https://github.com/jselbie/stunserver.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "52e9913b0a6208e305f6f5d0e64f6c2888be95f9c35674293d2a7bbde07dd5f1" => :catalina
    sha256 "87375257e1d4c3964587b59ef34a1800e9e9b7e6028a506a22b8cd695f39bf42" => :mojave
    sha256 "b5541fc2478ed4b97cdc5cf97ddbcbc4d76255b0ba9e834666c548612e9b758d" => :high_sierra
    sha256 "51f40332e70148118ca22eb7f393c002188e73fb59c82a44c689430f86b2bf7f" => :sierra
  end

  depends_on "boost" => :build
  depends_on "openssl@1.1"

  def install
    system "make"
    bin.install "stunserver", "stunclient", "stuntestcode"
  end

  test do
    system "#{bin}/stuntestcode"
  end
end
