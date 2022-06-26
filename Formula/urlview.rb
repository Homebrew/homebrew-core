class Urlview < Formula
  desc "URL extractor/launcher"
  homepage "https://packages.debian.org/sid/misc/urlview"
  url "https://deb.debian.org/debian/pool/main/u/urlview/urlview_0.9.orig.tar.gz"
  version "0.9-22"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec7eb261b52638ccf0a193278d606e3058ce535b977a260f987aae200151e890"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e108231d44ae30814b4028b79ab3d5cd4a96719baf1fdaf2f6ab37eb0e3a6120"
    sha256 cellar: :any_skip_relocation, monterey:       "bcc1a471d63b9a36ff5a2866d5e7426aca87b511f9bd8020d9be0183d0cbe791"
    sha256 cellar: :any_skip_relocation, big_sur:        "590b88c35280f2e37daacd2c510afeda9ff90c38361fa9b113a5925136dbdaa7"
    sha256 cellar: :any_skip_relocation, catalina:       "102860ddd181af6242b7aaae841e39dc05298856e43f4c7d9f8747e6d17ad8d1"
    sha256 cellar: :any_skip_relocation, mojave:         "2c93e736ee4b39f7567afe60fcb06ec2144ca054a819a3406caaa5c330ab4911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0a5093183e760ac371ca256f25880a33c0b1cc8d6e9da755745979b35303969"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "automake"
  end

  patch do
    url "https://deb.debian.org/debian/pool/main/u/urlview/urlview_0.9-22.diff.gz"
    sha256 "9a72630a6afa6b848d2c5db72f8dee8710678ff4d97145491465562c0f80ed46"
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
