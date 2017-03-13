class Stuntman < Formula
  desc "Implementation of the STUN protocol"
  homepage "http://www.stunprotocol.org/"
  url "http://www.stunprotocol.org/stunserver-1.2.13.tgz"
  sha256 "d336be76c23b330bcdbf7d0af9e82f1f4f9866f9caffd37062c7f44d9c272661"
  head "https://github.com/jselbie/stunserver.git"

  bottle do
    cellar :any
    sha256 "f3a17b16bfd32c4a888500edf6dd5db05e9ddbb72d8767ae86dfd11d5916c8c5" => :sierra
    sha256 "f25bb4553534d83eeefeffcd0af509f8d16dbd12480102154d9b7da8bb5b3828" => :el_capitan
    sha256 "51ccb9f6ef78dad5125b5d10c1d6943a5d04761e693ebe2a06e2c4f7da080d57" => :yosemite
  end

  depends_on "boost" => :build
  depends_on "openssl"

  def install
    system "make"
    bin.install "stunserver", "stunclient", "stuntestcode"
  end

  test do
    system "#{bin}/stuntestcode"
  end
end
