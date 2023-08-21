class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://github.com/rfc1036/whois"
  url "https://github.com/rfc1036/whois/archive/refs/tags/v5.5.18.tar.gz"
  sha256 "f0ecc280b5c7130dd8fe4bd7be6acefe32481a2c29aacb1f5262800b6c79a01b"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6586a1ca6d990a859625b0f44f150e9e254082ec63f170a96e6cdff08e3153a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a9ee8f6ff33a493dab0b30986ff5e3785de99b4efff9b81ec4eafe94534901a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb898b0100de920f5a29c52a89c022e2ab025723836644a9dacb35accfbe46f3"
    sha256 cellar: :any_skip_relocation, ventura:        "45cdf1d62cba3433025990db30e0e67f2d6f30e20007ff3f2c6d07cbb58f55f0"
    sha256 cellar: :any_skip_relocation, monterey:       "783a8fbff7c667eeacbfd42a0f536632e91a1f1dffa11815dcc679c39ee9d07f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1aadc25f43fa50cc49f13061b9da06f56bcc0df4c90e04ddc4f3c6893ed1a818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a59f698211639070f7c3b248285828de60cf46d46c5157da0990f130a63c713b"
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "libidn2"

  def install
    ENV.append "LDFLAGS", "-L/usr/lib -liconv" if OS.mac?
    # Workaround for Xcode 14.3.
    ENV.append_to_cflags "-Wno-implicit-function-declaration"

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
