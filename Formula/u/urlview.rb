class Urlview < Formula
  desc "URL extractor/launcher"
  homepage "https://packages.debian.org/sid/misc/urlview"
  url "https://deb.debian.org/debian/pool/main/u/urlview/urlview_0.9.orig.tar.gz"
  version "0.9-23"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e61de906c2ad7b7303b2b69b2c3cc33ac29d77b22c5ad79a8eca704339d0fd5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79e803c2e3dd3e77fa2c7792f7ca846e2c9fa9b614540792c9fb8bac3bb03b34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bd54ce3f197e6a1dbeada8a9e6927a3ca00b8c304b4389879a2cb15dd4db17a"
    sha256 cellar: :any_skip_relocation, ventura:        "52ce80dc709a61c1c64cff409b1f14edd802bc60954834d498762a51aa463fe8"
    sha256 cellar: :any_skip_relocation, monterey:       "c906ca088635e62fba1979b6f3a5767edf0f0649929b31900ab9513ccbbc6cc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ba2615a1ea02924d894084fdba9be8a6bc219dbfa852276fbcd330ad9c118ef"
    sha256 cellar: :any_skip_relocation, catalina:       "640e2ef08bf6e065c52b0f90832774049b9e9cd4cdeede8912ad8656c9c851af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6c16bac2771c3d20aecf067223c0562ec22ed824880f64d1260023364e73d0d"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "automake"
  end

  patch do
    url "https://deb.debian.org/debian/pool/main/u/urlview/urlview_0.9-23.diff.gz"
    sha256 "32dcff6d032ae23f100a42cb7b23573338033b5e0613b20813324ddb417ce86f"
  end

  def install
    url_handler = OS.mac? ? "open" : etc/"urlview/url_handler.sh"
    inreplace "urlview.man", "/etc/urlview/url_handler.sh", url_handler
    inreplace "urlview.c",
      '#define DEFAULT_COMMAND "/etc/urlview/url_handler.sh %s"',
      %Q(#define DEFAULT_COMMAND "#{url_handler} %s")

    man1.mkpath

    unless OS.mac?
      touch("NEWS") # autoreconf will fail if this file does not exist
      system "autoreconf", "-i"

      # Disable use of librx, since it is not needed on Linux.
      ENV["CFLAGS"] = "-DHAVE_REGEX_H"
      (etc/"urlview").install "url_handler.sh"
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      https://github.com/Homebrew
    EOS
    PTY.spawn("urlview test.txt") do |_r, w, _pid|
      sleep 1
      w.write("\cD")
    end
  end
end
