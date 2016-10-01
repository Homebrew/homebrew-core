class Stuntman < Formula
  desc "Implementation of the STUN protocol"
  homepage "http://www.stunprotocol.org/"
  url "http://www.stunprotocol.org/stunserver-1.2.9.tgz"
  sha256 "f63452869bccc6dc1ae55a9cce9e34fba3b96bb7b0f70ea33b211a0fb4eff49a"
  head "https://github.com/jselbie/stunserver.git"

  bottle do
    cellar :any
    sha256 "05ec3119000b41ebe8fec97bcf13832630bd60c5cf7c35b12b6b7a19bbd3ded5" => :sierra
    sha256 "0881a820844462a70725adb5fbf1df14b873dc7e30c603d7ef294569e9a017ac" => :el_capitan
    sha256 "dfa719526c70219fc276f65bbf95d51283e5e9609df712bf1a8f3950323b175c" => :yosemite
    sha256 "1e8299d93a333000f7f02a5525aa29b5ebf6b5490c3523a7eb27972d4c9bef77" => :mavericks
  end

  depends_on "boost" => :build
  depends_on "openssl"

  def install
    system "make"
    bin.install "stunserver", "stunclient", "stuntestcode"
  end

  test do
    system "#{bin}/stuntestcode"
  end
end
