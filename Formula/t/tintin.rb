class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.42/tintin-2.02.42.tar.gz"
  sha256 "ae3396fe40a246dd09d8c31a232202db1827a11e6fbebfa9b1f413e7fd1807c4"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f7e297d0dccb6ab59b5d6fe3b6e0a80e288fef30ccae1d15afe2e148d0f13082"
    sha256 cellar: :any,                 arm64_sonoma:  "baf16649efa1cb54f57f398d1feaa25cc9e4fde3bdcb97ea14b1c6f695a3e0aa"
    sha256 cellar: :any,                 arm64_ventura: "dcd49d734e84046e1517ff268c77660bbcd8ba8f7793a010f8f80b08c4ba19ba"
    sha256 cellar: :any,                 sonoma:        "698c40d0d6db51cdbe86646169120805cf53482072eede0ba54bdbd81780c700"
    sha256 cellar: :any,                 ventura:       "9c59d0ef2e18563f0d9e6b0d132a03b452ce67613c147d16753ac3f977f3fff3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8121a277dec9b7881db528e6752d1a2d23748fdcba1485a598a563ca1acd365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73211f73ffa77b2e9f5795784ea9440754c3e4a130a164d44b8e1bd059435505"
  end

  depends_on "gnutls"
  depends_on "pcre" # PCRE2 issue: https://github.com/scandum/tintin/issues/163

  uses_from_macos "zlib"

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
