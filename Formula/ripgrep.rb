class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher."
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.3.1.tar.gz"
  sha256 "08618425de89bdcd84f17a3bbf71a2d00a787de1f196e048059c01969065154e"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "779b408cdc6e70cce30142112bee477817968bcdeeb53de9fdddc1b1f56b24e3" => :sierra
    sha256 "6016fda414c7a9dd775acc7acd5ab76b77fee9573a322c59f0bcb0ff9d95bcd2" => :el_capitan
    sha256 "7446e36734461860209bc701c9fe8549a3779beccb9d811e017baddf47178d90" => :yosemite
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"

    bin.install "target/release/rg"
    man1.install "doc/rg.1"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/rg", "Hello World!", testpath
  end
end
