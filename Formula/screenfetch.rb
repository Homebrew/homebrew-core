class Screenfetch < Formula
  desc "Generate ASCII art with terminal, shell, and OS info"
  homepage "https://github.com/KittyKatt/screenFetch"
  url "https://github.com/KittyKatt/screenFetch/archive/v3.8.0.tar.gz"
  sha256 "248283ee3c24b0dbffb79ed685bdd518554073090c1c167d07ad2a729db26633"
  head "https://github.com/KittyKatt/screenFetch.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "5a351a099b84c85e6923e0aecc1504dd8e6b58e4b7a17fcfe6c7ad06b1803dc0" => :sierra
    sha256 "a432e872bbe8d87199d49a9806350e52247bb591c6732e736f082cf12329050a" => :el_capitan
    sha256 "f06711aa9632682d30fc81ecec15eb9822ed1946fa39880ba18a9d57a27c66d9" => :yosemite
    sha256 "ec75963396cf12dfd7277d6149a2aa87dd63079ddaccb2a03fd04e55f163e36b" => :mavericks
    sha256 "16810381df9a010c1c5c84dd1eba262e4e7b276a3e12ca87d5d0e2e3302545bd" => :mountain_lion
  end

  def install
    bin.install "screenfetch-dev" => "screenfetch"
    man1.install "screenfetch.1"
  end

  test do
    system "#{bin}/screenfetch"
  end
end
