# Documentation: https://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Sdfcli < Formula
  desc "NetSuite SDF CLI Tool"
  homepage "https://system.netsuite.com/app/help/helpcenter.nl?fid=chapter_4779302061.html"
  url "https://github.com/limebox/sdf/raw/master/Files/brew/sdfcli-17.2.0.tar.gz"
  sha256 "ceff6c2d3a4da0fc3a10dcea9721f81df1f83708ea879a6a293d608c6e1c5ed5"

  depends_on "maven" => "3.5+"

  def install

    bin.install "sdfcli", "sdfcli-createproject"
    libexec.install "pom.xml", "com.netsuite.ide.core_2017.2.0.jar"

  end

  test do
    system "#{bin}/sdfcli"
  end
end
