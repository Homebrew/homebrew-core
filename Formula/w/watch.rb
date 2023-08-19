class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps.git",
      tag:      "v4.0.3",
      revision: "806eb270f217ff7e1e745c7bda2b002b5be74be4"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://gitlab.com/procps-ng/procps.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0a5090f84e5392c6bf5d00bbf6f61cd99935165a8a05e74d7c97aa9ea25a99b1"
    sha256 cellar: :any,                 arm64_monterey: "02af446134c00742c47e54728d1084421b1fe1d7cc9757d27884ed05adf1e5be"
    sha256 cellar: :any,                 arm64_big_sur:  "9e9411d482540eaa77872dcb971e7aaed55f2938f3ef10bb8a24e4d39dab1c6e"
    sha256 cellar: :any,                 ventura:        "9c19ed7b3fd942dd2d889596a17c9d78469d8ab32a7e29eeaeeae3c0b2cdf09b"
    sha256 cellar: :any,                 monterey:       "cdf2be215979e9529f232f8fbc444ddfe2cfe025a8301e529248c1d8a0040ec3"
    sha256 cellar: :any,                 big_sur:        "89e4812e861078367f940028413f0bdaaf3a6f2d831f16e3f45022d54f855076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "834c0202985476955c535679f23c806a2fe1bbf7b11fcddea32ef3225fe0e2be"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "ncurses"

  conflicts_with "visionmedia-watch"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-nls",
                          "--enable-watch8bit"
    system "make", "src/watch"
    bin.install "src/watch"
    man1.install "man/watch.1"
  end

  test do
    system bin/"watch", "--errexit", "--chgexit", "--interval", "1", "date"
  end
end
