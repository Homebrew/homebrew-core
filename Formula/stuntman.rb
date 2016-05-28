class Stuntman < Formula
  desc "Implementation of the STUN protocol"
  homepage "http://www.stunprotocol.org/"
  url "http://www.stunprotocol.org/stunserver-1.2.9.tgz"
  sha256 "f63452869bccc6dc1ae55a9cce9e34fba3b96bb7b0f70ea33b211a0fb4eff49a"
  head "https://github.com/jselbie/stunserver.git"

  bottle do
    cellar :any
    sha256 "70c9db5d6503508bb29ea52a1bc006909abb4d03da9ad34a4d39fb42a2f5ea81" => :el_capitan
    sha256 "1704bb907134f990497cec59b9e279c88104e3bd723b999ac8b64d3f9e4c6ac7" => :yosemite
    sha256 "316bcef26dd5e39a141f4761c19919a249859d04992ab99d4417c23e383c5ffb" => :mavericks
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
