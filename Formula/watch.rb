class Watch < Formula
  desc "Executes a program periodically, showing output fullscreen"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps.git",
      :tag => "v3.3.13",
      :revision => "2fc2427ed374f96a5079e4b8b4a6d36192c873ac"
  head "https://gitlab.com/procps-ng/procps.git"

  bottle do
    sha256 "289a466b89e14630d18b963265976835f3f505630f72cd824a1d267a6acf9522" => :high_sierra
    sha256 "98cf549c8b1c06199e9f8baccdc1dcc3fc3c1f9a5195a1869de991598774d806" => :sierra
    sha256 "926d0be8053cf015dc06cf8fb4e6107902c2015acc8b69f1a77100034e078cfd" => :el_capitan
    sha256 "31b517c67875cbb8ca8bd8126af66561a8df0f61bee955ffdeac3eeb6021ec12" => :yosemite
    sha256 "fdedabfbc86a57b936be2ca1377c8749a6bce801baf74ef4444e7c75b9b6e0f0" => :mavericks
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
