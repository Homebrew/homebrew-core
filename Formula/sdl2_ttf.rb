class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://www.libsdl.org/projects/SDL_ttf/"
  url "https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.14.tar.gz"
  sha256 "34db5e20bcf64e7071fe9ae25acaa7d72bdc4f11ab3ce59acc768ab62fe39276"

  bottle do
    cellar :any
    sha256 "6420d0ad3f91d4683441a23323e347fa3116a5e484d810d896ac7a484a599e82" => :sierra
    sha256 "29e62db1a48f1cd9142c04d4a734298f30c8924b32eaa914a6aaef574d4a6f01" => :el_capitan
    sha256 "557067e99848b4b8a61c805eeb545c6ec66184b7fc2718dc3dd50bd551b0b324" => :yosemite
    sha256 "3b2dafa7edea6a2173c9ae17bb6a1cc5137a9004ffc44b6443bc885456adbb1b" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "freetype"

  def install
    ENV.universal_binary if build.universal?
    inreplace "SDL2_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
