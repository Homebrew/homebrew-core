class Shairport < Formula
  desc "Airtunes emulator"
  homepage "https://github.com/abrasive/shairport"
  url "https://github.com/abrasive/shairport/archive/1.1.1.tar.gz"
  sha256 "1b60df6d40bab874c1220d7daecd68fcff3e47bda7c6d7f91db0a5b5c43c0c72"
  head "https://github.com/abrasive/shairport.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "75a04ae35accc05373f970e293114567b3c6459cd3a22c4e5370f1031da2c42f" => :mojave
    sha256 "1fe3430874b5895dd8452ce4e688b6476ecfa3e61e2da66ee7edd7bd1c6b6df8" => :high_sierra
    sha256 "813a45b8e0dbc38efa55577f752a076169d0ff24a8d24a1c29426af78a47a591" => :sierra
    sha256 "506a28dff863f2a8e17058fead36c037e580f448faa68a459d2b739a756e1c13" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/shairport", "-h"
  end
end
