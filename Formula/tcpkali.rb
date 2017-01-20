class Tcpkali < Formula
  desc "High performance TCP and WebSocket load generator and sink"
  homepage "https://github.com/machinezone/tcpkali"
  url "https://github.com/machinezone/tcpkali/releases/download/v1.1/tcpkali-1.1.tar.gz"
  sha256 "e477b03f3e0aa45ddd5c058ea5e6107486983c2aa658a076b061af84c1ed61e7"

  bottle do
    cellar :any_skip_relocation
    sha256 "d37427e7fff546ae9ffb6bab7c77b275442cf21959ea3111b6eaefa1aef87c93" => :sierra
    sha256 "b1322c09c39a72419660646dd014af6cab694727f382ce784daaed19e6f13322" => :el_capitan
    sha256 "064726e4e45a932793bc61e4cae43b9dfc8631237bd2b6cf713280d3bb66ac5d" => :yosemite
  end

  # Upstream issue "1.1 release tarball is missing pcg_basic.h"
  # Reported 20 Jan 2016 https://github.com/machinezone/tcpkali/issues/39
  resource "pcg_basic_header" do
    url "https://raw.githubusercontent.com/machinezone/tcpkali/1be382b/deps/pcg-c-basic/pcg_basic.h"
    sha256 "cd823ddc225da9be520a54f13ef2c491506c353800cae04e8b673b2de58f2cc4"
  end

  def install
    raise "remove the resource" if File.exist? "deps/pcg-c-basic/pcg_basic.h"
    resource("pcg_basic_header").stage buildpath/"deps/pcg-c-basic"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tcpkali", "-l1237", "-T0.5", "127.1:1237"
  end
end
