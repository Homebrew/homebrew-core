class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.31/tintin-2.02.31.tar.gz"
  sha256 "f6359867f0c91ef2f1ddabd5e2d98b02b75bb0129470a824c9a0b143ff14e7c7"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5abf2cbdb5cd3e2ae9c01a5b29321d936e86f9d793551fb25f90a2f791ab4e3f"
    sha256 cellar: :any,                 arm64_monterey: "8b3b152050a13305b5b8f03f755368f4e046515c57d97e369037ff0fbbb8ded8"
    sha256 cellar: :any,                 arm64_big_sur:  "8cbe798a0f98f4101bd55a72b73af553f218e815caa084adec0005409413ddc2"
    sha256 cellar: :any,                 ventura:        "419693b6825e7aedc436a8591906a66cdc88b8296e6ce94bb6986c7eef2ddd02"
    sha256 cellar: :any,                 monterey:       "7f84c54c009d1fcafdae192e194479ce9c6603eaf7f4fe31c137c680fda0017a"
    sha256 cellar: :any,                 big_sur:        "ae668678e8c4b3c38561e26f7d98102138beb1f81917e5cb529cd925150560e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b702831ad086345f822a45e45eeab0e0d44e321593fd67eafcd34e0bec0c4d3d"
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
