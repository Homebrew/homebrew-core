class Stuntman < Formula
  desc "Implementation of the STUN protocol"
  homepage "http://www.stunprotocol.org/"
  url "http://www.stunprotocol.org/stunserver-1.2.15.tgz"
  sha256 "321f796a7cd4e4e56a0d344a53a6a96d9731df5966816e9b46f3aa6dcc26210f"
  revision 1
  head "https://github.com/jselbie/stunserver.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b14ec536bd7f490701c5106a0f4e438892c68054d6a048cac320da0e2e9e41e1" => :mojave
    sha256 "e6a85d92caccf0c1de31c2c24a54bd431cc220ee64b1ed3facbba7b53891b16e" => :high_sierra
    sha256 "dfa3e7ce02e11c079ba07194d848ef98d889230b0cfad42c88a78614a22d109d" => :sierra
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
