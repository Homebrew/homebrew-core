class Urlview < Formula
  desc "URL extractor/launcher"
  homepage "https://packages.debian.org/sid/misc/urlview"
  url "https://deb.debian.org/debian/pool/main/u/urlview/urlview_0.9.orig.tar.gz"
  version "0.9-21"
  sha256 "746ff540ccf601645f500ee7743f443caf987d6380e61e5249fc15f7a455ed42"
  license "GPL-2.0-or-later"

  # Since this formula incorporates patches and uses a version like `0.9-21`,
  # this check is open-ended (rather than targeting the .orig.tar.gz file), so
  # we identify patch versions as well.
  livecheck do
    url "https://deb.debian.org/debian/pool/main/u/urlview/"
    regex(/href=.*?urlview[._-]v?(\d+(?:[.-]\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "65a48245adafa4bfaaa8e7a08c371d9a15e39dc3672f33c5de2a97809a2222a7"
    sha256 cellar: :any_skip_relocation, big_sur:       "20e13c05f4e090cf897ae74480a5bbc2cafb47a7ba7c6b3a569c6bca14b1d0ea"
    sha256 cellar: :any_skip_relocation, catalina:      "1a29faf6b64714501b62a1ad36d33bbb133fc23515dfaa352c36b47b47ed8669"
    sha256 cellar: :any_skip_relocation, mojave:        "4949121abe0237bf3322701201873aa20a0c23746107b79bc696d6d728200b90"
    sha256 cellar: :any_skip_relocation, high_sierra:   "abe2ea4e7d7f07e606837852d3e46c72c56fd4018a703e72f0945d87ccba19a4"
  end

  on_linux do
    depends_on "automake"
  end

  patch do
    url "https://deb.debian.org/debian/pool/main/u/urlview/urlview_0.9-21.diff.gz"
    sha256 "efdf6a279d123952820dd6185ab9399ee1bf081ea3dd613dc96933cd1827a9e9"
  end

  def install
    inreplace "urlview.man", "/etc/urlview/url_handler.sh", "open"
    inreplace "urlview.c",
      '#define DEFAULT_COMMAND "/etc/urlview/url_handler.sh %s"',
      '#define DEFAULT_COMMAND "open %s"'

    man1.mkpath

    on_linux do
      touch("NEWS") # autoreconf will fail if this file does not exist
      system "autoreconf", "-i"
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end
end
