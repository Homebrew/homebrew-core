class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps.git",
      :tag => "v3.3.13",
      :revision => "2fc2427ed374f96a5079e4b8b4a6d36192c873ac"
  head "https://gitlab.com/procps-ng/procps.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "42288882673f4abdc89ee24cb88d2e76f2b32fec5d06148a26511b56c5be7ac3" => :high_sierra
    sha256 "ced897f72a92f243c81e20b62edda6daf32652d22752b2c12e305d42ebc6fdca" => :sierra
    sha256 "33b30a5929a98457abc9da46956d68bcc8059992f6386b8507a1c6c7b460355f" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "gettext"

  conflicts_with "visionmedia-watch"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-nls"
    system "make", "watch"
    bin.install "watch"
    man1.install "watch.1"
  end

  test do
    system bin/"watch", "--errexit", "--chgexit", "--interval", "1", "date"
  end
end
