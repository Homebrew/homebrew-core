class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher."
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.2.8.tar.gz"
  sha256 "0a2a41439572feed787b4e1e3d07d03b8ee6a7dd2dc0eda969eb7d67aed91e52"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6520d3c3105bcb3bdc095ac9d0ebff5769fed9b4d9f288d003c1378e3b9c518" => :sierra
    sha256 "bbda30924d09ae3b9c9cdd3fb49ad4b9e5b7f2daa67b7b9af7acb7cd0a579be1" => :el_capitan
    sha256 "76ae673cd5d24e9ae3a4c0c4e7c8468a85680f02dd25c8b9b43c15f694ad819c" => :yosemite
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
