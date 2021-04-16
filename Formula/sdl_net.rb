class SdlNet < Formula
  desc "Sample cross-platform networking library"
  homepage "https://www.libsdl.org/projects/SDL_net/release-1.2.html"
  url "https://www.libsdl.org/projects/SDL_net/release/SDL_net-1.2.8.tar.gz"
  sha256 "5f4a7a8bb884f793c278ac3f3713be41980c5eedccecff0260411347714facb4"

  livecheck do
    url "https://www.libsdl.org/projects/SDL_net/release/"
    regex(/href=.*?SDL_net[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "99b9b5259989971316f1ab7d1c785949868b329abe2e73b0034bdfe5f447eeb8"
    sha256 cellar: :any, big_sur:       "53bf15367d717f52383f6221a46c2103ed88beb591830f7d6269b9ae993521f7"
    sha256 cellar: :any, catalina:      "4c4cf23a69b5bc903e23e919a87ab1c02ed2e65580b8071ea7fe4d40fdb6de55"
    sha256 cellar: :any, mojave:        "42ba6a6ea66082574335d2db119cdeedb53865f01344a8bab255094b09223bc7"
    sha256 cellar: :any, high_sierra:   "6ef784ef221c9eeea648834070ec1d20bac11cdc9754f5af2fe5dd6fa04e0f10"
    sha256 cellar: :any, sierra:        "65cc3ae3104620de06f03ca0d9b3a545d90f2a36955dcb528f5f42af6db11bcf"
    sha256 cellar: :any, el_capitan:    "036938975b4060fdc944c2258a8d1d5d73f536860a9c807116e6c4fb2aa65dc8"
    sha256 cellar: :any, yosemite:      "fe6b8eda1d640db450ed12f79feb731d49a62263c4b83601d69659498d697538"
  end

  depends_on "pkg-config" => :build
  depends_on "sdl"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-sdltest"
    system "make", "install"
  end
end
