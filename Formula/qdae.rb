class Qdae < Formula
  desc "Quick and Dirty Apricot Emulator"
  homepage "https://www.seasip.info/Unix/QDAE/"
  url "https://www.seasip.info/Unix/QDAE/qdae-0.0.10.tar.gz"
  sha256 "780752c37c9ec68dd0cd08bd6fe288a1028277e10f74ef405ca200770edb5227"
  license "GPL-2.0"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?qdae[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "c02eda593d7a7ac35abf1cd2bf5ec95bb1b1e584decb233e35f8ad4aae314722"
    sha256 arm64_big_sur:  "fa62d313254002b0ccb853ee858a951e653965931860baf1ec86eec04bb7c5c2"
    sha256 monterey:       "bd4903d11b7034d223568cdff4418e2898f280cd89e2158c466d0034c7f0a8ee"
    sha256 big_sur:        "3159379cafe1e96621731f0ec1c7cb3d9dd549785a6405a5ddf764b9fc7fcae1"
    sha256 catalina:       "055055ee771ea663acbe4babe37f6ebdd9cfaf4c0e4600f8db6ba3b753c2bc36"
    sha256 x86_64_linux:   "e89eeee0fb9a7b290003f85e0338ab747c18cbd2724737e20cd742bb3c5634ef"
  end

  depends_on "sdl"

  uses_from_macos "libxml2"

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Data files are located in the following directory:
        #{share}/QDAE
    EOS
  end

  test do
    assert_predicate bin/"qdae", :executable?
  end
end
