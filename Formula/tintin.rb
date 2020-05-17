class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.03/tintin-2.02.03.tar.gz"
  sha256 "e44c88b1c97283525062ce15efdddebf5067e84ea37491903bcd8c8824f26f79"

  bottle do
    cellar :any
    sha256 "895be37bb90b25cdc58591aa166bd464538715c3104901c7159d3c58906a485b" => :catalina
    sha256 "ecdd874018dd20cd4d8807a8c2adc5a8955622f8c97277a3a6fdc79e3d8a4198" => :mojave
    sha256 "29c68a3db90dee5cef629f629629d50469f2dd0ef9426b4bd8aaa374d2b6334e" => :high_sierra
  end

  depends_on "gnutls"
  depends_on "pcre"

  def install
    # find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make", "CFLAGS=#{ENV.cflags}",
                     "INCS=#{ENV.cppflags}",
                     "LDFLAGS=#{ENV.ldflags}",
                     "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tt++ -V", 1)
  end
end
