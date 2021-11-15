class Tcptrace < Formula
  # The tcptrace.org site has a history of going down sometimes, which is why
  # we're using mirrors even though the first-party site may be available.
  desc "Analyze tcpdump output"
  homepage "http://www.tcptrace.org/"
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/tcptrace/tcptrace-6.6.7.tar.gz"
  mirror "https://distfiles.macports.org/tcptrace/tcptrace-6.6.7.tar.gz"
  sha256 "63380a4051933ca08979476a9dfc6f959308bc9f60d45255202e388eb56910bd"

  # This site has a history of going down for periods of time, which is why the
  # formula uses mirrors. This is something to be aware of if livecheck is
  # unable to find versions.
  livecheck do
    url "http://www.tcptrace.org/download.shtml"
    regex(/href=.*?tcptrace[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc1e3a00440e80a1b1ad88fc3ab0c872f47bd1f9d8fa9909add44144f3703be8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d27d973e94299d333fdd27c65e1260ee1c8ef12361a33e98a10cde109c781433"
    sha256 cellar: :any_skip_relocation, monterey:       "82fa4c9aa859f61dd6f2ca36078b41b9994196d975a82b09b77529069a6fe195"
    sha256 cellar: :any_skip_relocation, big_sur:        "64787cc311c9da8d2090af5732efbe42f74c6dc5037b2b7ecb7055485603f20d"
    sha256 cellar: :any_skip_relocation, catalina:       "a1a61bd690da912afedd38f62eac7d5a1724c1ce68c68e7bcd8576e3fb86d956"
    sha256 cellar: :any_skip_relocation, mojave:         "b927868b2addc93b296fb8f31b08147014e9a81a356d4f18b0d4134db40081de"
    sha256 cellar: :any_skip_relocation, high_sierra:    "39916506fcd6385aee6375813128a126a84f947623594011f6c2c9df1b6dc8b2"
    sha256 cellar: :any_skip_relocation, sierra:         "7ccc5e6859be970a5a8a064630704111d37b03a7e3cf3a9874e16a60e4abe02b"
    sha256 cellar: :any_skip_relocation, el_capitan:     "e46775d7cc808b5b52a0a36a33142b824a9b2d8bce5b0557bc1041c2e55c5ffb"
    sha256 cellar: :any_skip_relocation, yosemite:       "f9de7ef41a2b9dc8daee1fddef1035ddf6a08cf473b6edafcf4bb069ab5f0052"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "tcptrace"

    # don't install with owner/group
    inreplace "Makefile", "-o bin -g bin", ""
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man}"
  end

  test do
    touch "dump"
    assert_match(/0 packets seen, 0 TCP packets/,
      shell_output("#{bin}/tcptrace dump"))
  end
end
