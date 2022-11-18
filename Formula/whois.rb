class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.5.14.tar.xz"
  sha256 "bf9c2cb307d5419b34ad401eecf2820b8f69660db41cf0762e5da71fa2df68e8"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "340adbc5d5bacc197c252b34bbdcffc7dee121592dd36e2b5271b251a6ba3b7f"
    sha256 cellar: :any,                 arm64_monterey: "cde452357f82ac8bedf2353c9109a6178a86fcfa8fc4faf91faede038c04b461"
    sha256 cellar: :any,                 arm64_big_sur:  "9e8f8166f2d5cab313f02aa194f4eb165df351c9a3b284a37c71bbcd75e1e79c"
    sha256 cellar: :any,                 ventura:        "7e7b44f7f49e14832b0bd2a9bec20a610bd0b79d914ee786569f1ad6428bd86d"
    sha256 cellar: :any,                 monterey:       "4910dd000629e19c72c7349972f8d3f15d4e4c8f9d515dc2bbe800e217c26730"
    sha256 cellar: :any,                 big_sur:        "e2b20d884b4fb48d578b5509b242044aa5b4a6c5a83a0774ac098a5a86f424c6"
    sha256 cellar: :any,                 catalina:       "0f7260067dcfc8729651fd5a8a0e7d0bedbde36838976d56e47b160f8fb548ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f863b329e7044a90e91c6d38bb50e3f43953eeab6fd298a6ce5084de5518b981"
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "libidn2"

  def install
    ENV.append "LDFLAGS", "-L/usr/lib -liconv" if OS.mac?

    have_iconv = if OS.mac?
      "HAVE_ICONV=1"
    else
      "HAVE_ICONV=0"
    end

    system "make", "whois", have_iconv
    bin.install "whois"
    man1.install "whois.1"
    man5.install "whois.conf.5"
  end

  test do
    system "#{bin}/whois", "brew.sh"
  end
end
