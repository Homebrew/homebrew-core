class Setweblocthumb < Formula
  desc "Assigns custom icons to webloc files"
  homepage "https://hasseg.org/setWeblocThumb/"
  url "https://github.com/ali-rantakari/setWeblocThumb/archive/v1.0.0.tar.gz"
  sha256 "0258fdabbd24eed2ad3ff425b7832c4cd9bc706254861a6339f886efc28e35be"

  bottle do
    cellar :any_skip_relocation
    sha256 "6849eb0b22ee09260daa9432881f66dbb97ef44b26e1d469ca11d316658ee4f2" => :catalina
    sha256 "95ec7fa6fc12d232f0ce75089ec987d91a922752578447a68e9170de743d5552" => :mojave
    sha256 "8d7536c3ba30dc46c4e3a0f2e4be411d3e8b06be939a5130c67d2094da0cef4e" => :high_sierra
    sha256 "563620905a209f198f30bbffc9177294b224cee3098719af6da8cfca74092157" => :sierra
    sha256 "2a9c327d5d594d00d7d283d6627a5eeef160731616aec9d62bab017b52d71f1a" => :el_capitan
    sha256 "f55cbbabd19c245e42249b8d75c51b4fcec05d6d08674a448bf6e7a3da70aae5" => :yosemite
    sha256 "fa6ca731192b7645165ab28c148122688e5e584e2de1c8b500371d1c36cf9dda" => :mavericks
  end

  def install
    system "make"
    bin.install "setWeblocThumb"
  end

  test do
    Pathname.new("google.webloc").write('{URL = "https://google.com";}')
    system "#{bin}/setWeblocThumb", "google.webloc"
  end
end
