class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher."
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.2.3.tar.gz"
  sha256 "a88531558d2023df76190ea2e52bee50d739eabece8a57df29abbad0c6bdb917"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff0f826ab6e081110a6877dd2afc76381ae282f5984a81bb778858018db4831a" => :sierra
    sha256 "584ef400386f4cc6b768fc2efe2a3607865744e5d8751c1e2f8e9bb81d7fd806" => :el_capitan
    sha256 "d6466efbe4564f58f4615a544641a53044fa2d6b6360cb1282167fdb19f62c83" => :yosemite
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
