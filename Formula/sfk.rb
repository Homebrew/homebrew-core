class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.8.9.2/sfk-1.8.9.tar.gz"
  version "1.8.9.2"
  sha256 "b95a2840af410a15856b5f6e56858cb9284ae7675ac5676e418da78a1111cbd8"

  bottle do
    cellar :any_skip_relocation
    sha256 "d863bf1411f43dfd13c5e29e65eb3bdf7566e52a57562b5aa65ededaff9141c2" => :high_sierra
    sha256 "d51e7807904fc018f26b5d3fb84c67912e33ceeac8f0c4a8d02dd4829861f87c" => :sierra
    sha256 "f743a00bedba7b74ef4a5e6886f0878b846b113cea28f3b07c1bea4c8e31778e" => :el_capitan
  end

  def install
    ENV.libstdcxx

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end
