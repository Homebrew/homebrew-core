class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.51/tintin-2.02.51.tar.gz"
  sha256 "9279f25d18defddf449863f4bad6ec971feacd297a9d9ddaac28c9b5d5eced02"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c79e4c05084a38e2dce0d540e32dad034ded6da9669f4351a8e1ee4f3f749bc5"
    sha256 cellar: :any,                 arm64_sequoia: "c8410631e4b5913d30deff7f49b6c1f0b8e5d86b9aa894a61a5a61138ce4a8fe"
    sha256 cellar: :any,                 arm64_sonoma:  "699fae6ad2d5b69edb8a966d22364e25c27485084d3c8a55d6b767680e4be03e"
    sha256 cellar: :any,                 arm64_ventura: "27270803fb800ee49cd574dcbfa6a7d2e3dd18e4baf5a7d04107684421d15849"
    sha256 cellar: :any,                 sonoma:        "39d054d89de62da4d8e05f4f85e33bcf7eaac2ac6ca5567138bc9b0dbf94b912"
    sha256 cellar: :any,                 ventura:       "1bf5c897c70f625d4d2b115b832470b7ff7009caf600f03b4a6075fc66c1b813"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12d800c80fab044fd6ac3cc2052516797095394b8e5e532e8e59c7a3bb0dd52f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "135f4682a04e95b104a5bcb6ac078c42bd87cc5c355a455c96d9ae796ce9d34a"
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
