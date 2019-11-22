class Wbox < Formula
  desc "HTTP testing tool and configuration-less HTTP server"
  homepage "http://hping.org/wbox/"
  url "http://www.hping.org/wbox/wbox-5.tar.gz"
  sha256 "1589d85e83c8ee78383a491d89e768ab9aab9f433c5f5e035cfb5eed17efaa19"

  bottle do
    cellar :any_skip_relocation
    sha256 "512db23fe4356c552e240cf3457ff50225bb6d01fd786df356fb39e4b8f18288" => :catalina
    sha256 "bce72c30f26da03ab104082abaccd775fa721b4db98a0ae6e16e2946f59a8bed" => :mojave
    sha256 "6e8b41d8caf8ae84cf5ff0d7fe9bdb7d83b9c7afae9a746fe319e67fe145cf2c" => :high_sierra
    sha256 "241edb51af197d72022a48cb8444506188269b335b057ceaa7bf952db86777d8" => :sierra
    sha256 "0e813a0982d6b9228217f14352812d9e6880cce44757f8af9a0447bf5e4a1e63" => :el_capitan
    sha256 "ee2bd7599a73c3a9f3fe9f8c2d441d753914981b2420e591050780d436bbf011" => :yosemite
    sha256 "35b640ce39cd36f75ec595215099f121feb517672fb11abf30b36a1e567fc117" => :mavericks
  end

  def install
    system "make"
    bin.install "wbox"
  end

  test do
    system "#{bin}/wbox", "www.google.com", "1"
  end
end
