class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps.git",
      :tag => "v3.3.14",
      :revision => "3afea8abab5679a71e5e8832ca546614c06676c8"
  head "https://gitlab.com/procps-ng/procps.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a216f95274301c5babd6c5a7956a64448fe512854e5438b960279ad9d3b80e7" => :high_sierra
    sha256 "0c0dca64ca895ece4685a131c3de6704e7f593cf5d6446f873e02fbf271cef98" => :sierra
    sha256 "de2bfa2d25f2e85d6b24b4c943d2d29e9204f0aa26160647d183fa23c3ce5803" => :el_capitan
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
