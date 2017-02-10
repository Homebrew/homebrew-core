class Rawgl < Formula
  desc "Rewritten engine for Another World"
  homepage "http://cyxdown.free.fr/rawgl/"
  url "https://github.com/cyxx/rawgl/archive/rawgl-0.2.1.tar.gz"
  sha256 "da00d4abbc266e94c3755c2fd214953c48698826011b1d4afbebb99396240073"
  head "https://github.com/cyxx/rawgl.git"

  bottle do
    cellar :any
    sha256 "73791cd66afb8da8c36bfcec4ffda39fbd4db8bf94e5112dff8bda46462c3365" => :sierra
    sha256 "83711f3b4e919fbe21d02221356ad3e0108ee00739c699eb1acf79f2be8b6b18" => :el_capitan
    sha256 "b453fd2cf86a0299e372222942500f0b816165218ce0dec1726e0be493cf77c9" => :yosemite
  end

  depends_on "sdl2"
  depends_on "sdl2_mixer"

  def install
    system "make"
    bin.install "rawgl"
  end

  test do
    system bin/"rawgl", "--help"
  end
end
