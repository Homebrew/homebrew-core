class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://www.libsdl.org/projects/SDL_ttf/"
  url "https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.14.tar.gz"
  sha256 "34db5e20bcf64e7071fe9ae25acaa7d72bdc4f11ab3ce59acc768ab62fe39276"

  bottle do
    cellar :any
    sha256 "a132a5656ba547e19361adab1e49ed84c2d3e379496058e8b39ebc676c77e2cc" => :high_sierra
    sha256 "6420d0ad3f91d4683441a23323e347fa3116a5e484d810d896ac7a484a599e82" => :sierra
    sha256 "29e62db1a48f1cd9142c04d4a734298f30c8924b32eaa914a6aaef574d4a6f01" => :el_capitan
    sha256 "557067e99848b4b8a61c805eeb545c6ec66184b7fc2718dc3dd50bd551b0b324" => :yosemite
    sha256 "3b2dafa7edea6a2173c9ae17bb6a1cc5137a9004ffc44b6443bc885456adbb1b" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "freetype"

  def install
    inreplace "SDL2_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_ttf.h>

      int main()
      {
          int success = TTF_Init();
          TTF_Quit();
          return success;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lsdl2_ttf", "test.c", "-o", "test"
    system "./test"
  end
end
