class Urlview < Formula
  desc "URL extractor/launcher"
  homepage "https://packages.debian.org/sid/misc/urlview"
  url "https://deb.debian.org/debian/pool/main/u/urlview/urlview_0.9.orig.tar.gz"
  version "0.9-24"
  sha256 "746ff540ccf601645f500ee7743f443caf987d6380e61e5249fc15f7a455ed42"
  license "GPL-2.0-or-later"

  # Since this formula incorporates patches and uses a version like `0.9-21`,
  # this check is open-ended (rather than targeting the .orig.tar.gz file), so
  # we identify patch versions as well.
  livecheck do
    url "https://deb.debian.org/debian/pool/main/u/urlview/"
    regex(/href=.*?urlview[._-]v?(\d+(?:\.\d+)*[a-z]?(?:-\d+(?:\.\d+)*)?)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7573ee9d9ec6ad057e1942b86cdc5f87d1200edfa87671394efd95fef009908"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bd9f4ace151dc3bdd13ab54546319f4c3453a4d4255fd0acad4b720a683fc6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b567514b30c1ee47b2ccd0d37913b753fe12b5f8171a50df6a27f084cee86764"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bf235ca8f0965c5f2ed2fed715ba1ef442edf015e815804d88a5f4ee9c6810e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2b0b467e190129c65fdbf47e5d71d5f78d80fd438f9587ee0ccd8f9dc752b1f"
    sha256 cellar: :any_skip_relocation, ventura:        "f23b48aa03b4a6bbbff88712b5ae0b854d384aba75782ba4d9c9729f150d3653"
    sha256 cellar: :any_skip_relocation, monterey:       "758abed3f78263e758f923d939501ad1a020f6a13a2f517f96114686cd235141"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f33d54be1cd6b13f0f164bed70ef1aae7785d981a05eb2465baf11fa85fdb5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6adb97eddda5ed91facdbc759340569c66ce895d603120b17e6b271f03348f1e"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "automake"
  end

  patch do
    url "http://ftp.debian.org/debian/pool/main/u/urlview/urlview_0.9-24.debian.tar.xz"
    sha256 "2dd710baa5af98f5dc32ffedfa051220a83cb8b1d7250e75966d7658cf2e2228"
    apply "patches/debian.patch",
          "patches/Fix-warning-about-implicit-declaration-of-function.patch",
          "patches/invoke-AM_INIT_AUTOMAKE-with-foreign.patch",
          "patches/Link-against-libncursesw-setlocale-LC_ALL.patch",
          "patches/Allow-dumping-URLs-to-stdout.patch"
  end

  def install
    man1.mkpath

    url_handler = OS.mac? ? "open" : etc/"urlview/url_handler.sh"
    inreplace "urlview.man", "/etc/urlview/url_handler.sh", url_handler
    inreplace "urlview.c",
      '#define DEFAULT_COMMAND "/etc/urlview/url_handler.sh %s"',
      %Q(#define DEFAULT_COMMAND "#{url_handler} %s")

    unless OS.mac?
      touch("NEWS") # autoreconf will fail if this file does not exist
      system "autoreconf", "-i"

      # Disable use of librx, since it is not needed on Linux.
      ENV["CFLAGS"] = "-DHAVE_REGEX_H"
      (etc/"urlview").install "url_handler.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
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
