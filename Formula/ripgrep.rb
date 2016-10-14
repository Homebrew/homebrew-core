class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher."
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.2.3.tar.gz"
  sha256 "a88531558d2023df76190ea2e52bee50d739eabece8a57df29abbad0c6bdb917"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f01bd007f11a52584a13311f8c5d07273165041b55d2b29092eb00cc3b776fe9" => :sierra
    sha256 "55fff501f56c25413cef2cdd9df32bb3e2339256728f6b3d6dc59e2a49159cd4" => :el_capitan
    sha256 "1cfd3d638d0520b4f2bd370c8671a9d29f99316ebee963d86e27ad89ca694fbf" => :yosemite
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
