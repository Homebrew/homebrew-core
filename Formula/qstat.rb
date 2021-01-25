class Qstat < Formula
  desc "Query Quake servers from the command-line"
  homepage "https://github.com/multiplay/qstat"
  url "https://github.com/multiplay/qstat/archive/v2.14.tar.gz"
  sha256 "ae906b74d4cce8057b5a265b76859101da8104c2a07c05f11a51f7c9f033ef8b"
  license "Artistic-2.0"

  bottle do
    sha256 "f66049d57069d1219f9472d1c221f9732e985c31ef97f5a848e2e248ad3c029d" => :big_sur
    sha256 "57bf44e063bb7b5473ae34b3ec82c2fc09864ac2f9f41ccf62aecbd6c8b72bcc" => :arm64_big_sur
    sha256 "5bc0a1ad5cab40a918bddf42ffc58283177914ceca264b2cfd1e0687a033185f" => :catalina
    sha256 "4f97be89fba9e19e7a0d1285c6c3c8abb12021c0729e45295431072439841bb9" => :mojave
    sha256 "d6f890c9c0b11e038d1cf332437efef0ca9fe8e0a57cd8d78f1d68152e96ec44" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qstat", "--help"
  end
end
