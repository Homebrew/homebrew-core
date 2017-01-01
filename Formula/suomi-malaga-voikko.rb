class SuomiMalagaVoikko < Formula
  desc "Linguistic software and data for Finnish"
  homepage "http://voikko.puimula.org/"
  url "http://www.puimula.org/voikko-sources/suomi-malaga/suomi-malaga-1.19.tar.gz"
  sha256 "5c4c15dd87a82e9b8ab74f9c570c6db011e3fd824db4de47ffeb71c4261451cc"

  head "https://github.com/voikko/corevoikko.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b43ea26536db5a2d9b603120631f924a2b828e01f1e677517f83b0914e7c4772" => :sierra
    sha256 "1402b69243b64a12e2bf4be910e8769119f9b21818ecb1ce81e561e07925f8ba" => :el_capitan
    sha256 "78f4500efc866e46faaf1782800785ce97fd4b560e791723f00279f62da56dc6" => :yosemite
  end

  depends_on "malaga"

  def install
    Dir.chdir "suomimalaga" if build.head?
    system "make", "voikko"
    system "make", "voikko-install", "DESTDIR=#{lib}/voikko"
  end
end
