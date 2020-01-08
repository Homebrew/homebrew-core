class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.3.2/tcpreplay-4.3.2.tar.gz"
  sha256 "4f479bd9196cafde70c58ab072ca4959ecc5278555cf1aa7cf42f7f210daa951"

  bottle do
    cellar :any
    sha256 "73e450e25334a4a3aec93edccfcfc485e8c19cb1a7cad4840295bd598a173c65" => :catalina
    sha256 "502523def8034da8a129f830457c2d7fb5ac6e3ebde96370c8c2756508c7bdda" => :mojave
    sha256 "47ee8b4473546821e5e118527de761e9aa6782055a9ca3c3b64d4b70ee0f2d5d" => :high_sierra
    sha256 "fb7821ce52c21f7e880cc1ef5665d08a967ba79fc7fbea48b676ab151f5e7eb8" => :sierra
  end

  depends_on "libdnet"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-dynamic-link"
    system "make", "install"
  end

  test do
    system bin/"tcpreplay", "--version"
  end
end
