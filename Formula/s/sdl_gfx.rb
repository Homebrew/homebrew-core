class SdlGfx < Formula
  desc "Graphics drawing primitives and other support functions"
  homepage "https://www.ferzkopp.net/wordpress/2016/01/02/sdl_gfx-sdl2_gfx/"
  url "https://www.ferzkopp.net/Software/SDL_gfx-2.0/SDL_gfx-2.0.27.tar.gz"
  sha256 "dfb15ac5f8ce7a4952dc12d2aed9747518c5e6b335c0e31636d23f93c630f419"
  license "Zlib"

  livecheck do
    url :homepage
    regex(/href=.*?SDL_gfx[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "381ea9b6f234c356584b80d741e6109ebf16d11ed6bafd418e47f90937ce5cd5"
    sha256 cellar: :any,                 arm64_sequoia:  "975c8ba619e76b078e5cab50d4b8b0185e4b238f9dd06c7330c56d7a0a062f0f"
    sha256 cellar: :any,                 arm64_sonoma:   "df95d076e726afc8058f9071a82279c82e27d8b997b2afefb59081a6d4ec7bb6"
    sha256 cellar: :any,                 arm64_ventura:  "becf09fc1b01e3e6a7ebfd8b9410ffc02f81bff17bca272b2141a425f5a363ea"
    sha256 cellar: :any,                 arm64_monterey: "aff5d8b5fedee006203c3e615b94c5be69ed55b1c91c771d7c7bf238bce3670d"
    sha256 cellar: :any,                 sonoma:         "a474c0441ce725279640921c2fe1f7fce7dbdba78798b83b5e6d1088f257a0b8"
    sha256 cellar: :any,                 ventura:        "3a33a66abb0aab1556d4ad0aaea1dd87e51f5370a3c160cf571f960035139a89"
    sha256 cellar: :any,                 monterey:       "248ed5e56d43d6d8a72bb814f5cab225df686331af62b471f048dd43116a43b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1fbeee1c1d7079897509eca368e50b98e1069231605033f775fed43199a99da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0d9c2a0a9a19755c096b6e3718be733b85336f11aee29d6d7ce6ee04305cf42"
  end

  depends_on "sdl12-compat"

  def install
    extra_args = []
    extra_args << "--disable-mmx" if Hardware::CPU.arm?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest",
                          *extra_args
    system "make", "install"
  end
end
