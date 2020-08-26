class Spider < Formula
  desc "small dart library to generate Assets dart code from assets folder."
  homepage "https://github.com/BirjuVachhani/spider"
  url "https://github.com/BirjuVachhani/spider/releases/download/1.0.1/spider-1.0.1-macos.tar.gz"
  sha256 "b746721ca3809b2bdd2285a4e78ca5f7e5a692d122cf524f76f4ec330877bf7a"
  license "Apache-2.0"
  
  bottle :unneeded

  def install
    bin.install "spider"
  end
  
  test do
    system "#{bin}/spider", "--version"
    system "touch", "pubspec.yaml"
    system "#{bin}/spider", "create"
    raise 'test failed' unless File.exists? 'spider.yaml'
  end
end