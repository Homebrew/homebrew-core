class Screenfetch < Formula
  desc "Generate ASCII art with terminal, shell, and OS info"
  homepage "https://github.com/KittyKatt/screenFetch"
  url "https://github.com/KittyKatt/screenFetch/archive/v3.9.0.tar.gz"
  sha256 "d6df4ef7763f9761d818c878465d78ef701b71002a50d4f150f65a31cc1bea37"
  head "https://github.com/KittyKatt/screenFetch.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "4ebc2dbe3075fdb801971050cf9f5970142309c4473e72fa78c4f18de5db2933" => :catalina
    sha256 "4ebc2dbe3075fdb801971050cf9f5970142309c4473e72fa78c4f18de5db2933" => :mojave
    sha256 "4ebc2dbe3075fdb801971050cf9f5970142309c4473e72fa78c4f18de5db2933" => :high_sierra
  end

  def install
    bin.install "screenfetch-dev" => "screenfetch"
    man1.install "screenfetch.1"
  end

  test do
    system "#{bin}/screenfetch"
  end
end
