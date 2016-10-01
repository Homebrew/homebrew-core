class Setweblocthumb < Formula
  desc "Assigns custom icons to webloc files"
  homepage "http://hasseg.org/setWeblocThumb"
  url "https://github.com/ali-rantakari/setWeblocThumb/archive/v1.0.0.tar.gz"
  sha256 "0258fdabbd24eed2ad3ff425b7832c4cd9bc706254861a6339f886efc28e35be"

  bottle do
    cellar :any_skip_relocation
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
