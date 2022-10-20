class Remake < Formula
  desc "GNU Make with improved error handling, tracing, and a debugger"
  homepage "https://bashdb.sourceforge.io/remake"
  url "https://downloads.sourceforge.net/project/bashdb/remake/4.3%2Bdbg-1.6/remake-4.3%2Bdbg-1.6.tar.gz"
  version "4.3-1.6"
  sha256 "f6a0c6179cd92524ad5dd04787477c0cd45afb5822d977be93d083b810647b87"
  license "GPL-3.0-only"

  # We check the "remake" directory page because the bashdb project contains
  # various software and remake releases may be pushed out of the SourceForge
  # RSS feed.
  livecheck do
    url "https://sourceforge.net/projects/bashdb/files/remake/"
    regex(%r{href=.*?remake/v?(\d+(?:\.\d+)+(?:(?:%2Bdbg)?[._-]\d+(?:\.\d+)+)?)/?["' >]}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.sub(/%2Bdbg/i, "") }
    end
  end

  bottle do
    sha256 arm64_monterey: "5c2479d3270cb34d5515d80136186d003e9eb96c7750b137d6f526a46b4003f7"
    sha256 arm64_big_sur:  "b4370edfc5a075b5feb54686ba20b01dd2b2da18666b708ea5154af3b7df2c9b"
    sha256 monterey:       "609d23982a7c58ec3dc547e06dfc2f461b36ca622de3314490975a282117b9d4"
    sha256 big_sur:        "bc482278bbce34be601363a34689176e611eacc0461984892bdee53cc5965936"
    sha256 catalina:       "dc5e00c02c1def048f5d678e91349d8f8da951e8ada948d9f7538cc962d8feea"
    sha256 x86_64_linux:   "450f4449921dacd7b78dd3194ead086ea99e224a4ecac433118e47b84979d485"
  end

  depends_on "readline"

  conflicts_with "make", because: "both install texinfo files for make"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all:
      \techo "Nothing here, move along"
    EOS
    system bin/"remake", "-x"
  end
end
