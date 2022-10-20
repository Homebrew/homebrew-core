class Tintin < Formula
  desc "MUD client"
  homepage "https://tintin.mudhalla.net/"
  url "https://github.com/scandum/tintin/releases/download/2.02.20/tintin-2.02.20.tar.gz"
  sha256 "331673e6ee3c945cf27e1c0d71cec1225c9d992588ed73b2a707c4c49523e8d2"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "22df076cf26294cfcc4916a5207da44c5b09e666214ac492f00a4cc834cf5686"
    sha256 cellar: :any,                 arm64_big_sur:  "edb2f64c84e44ad7f1b76a1c5ec412dc94070fda47e902d1a69d9baa3db611f7"
    sha256 cellar: :any,                 monterey:       "09bbec9d3b0c8fa2ea32b82a338cb8ccfcaa5f14c563fc5d1fd9b22ff0f47a69"
    sha256 cellar: :any,                 big_sur:        "4395014464314a01722a142094b0ac57a3287f444dea2b188d42db858f215332"
    sha256 cellar: :any,                 catalina:       "61e87a3cbbecbf6a0675d03118edb516a6e570ed9f442f92afacaa0979437986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17d90efb0dcd0a31a260531ffe10e5e2e87253ad8570f2dc931082acba886d94"
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
