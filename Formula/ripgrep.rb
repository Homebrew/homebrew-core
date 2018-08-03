class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.9.0.tar.gz"
  sha256 "871a24ad29a4c5b6d82f6049156db2662e6a9820cca6f361547b8ab8bc1be7ae"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    sha256 "e653274f21c9e0999512f7afd79490920c1ef70b6f22920088153f02aca3ef5c" => :high_sierra
    sha256 "254e9f86612959b580f200351051ba280f69d4e90b130788fde98803b9af2404" => :sierra
    sha256 "ec3feeb2827f940b783545b9b8fc9b42b54ea0d8307655d682fa24df70cd4f43" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "rust" => :build

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "cargo", "install", "--root", prefix

    # Completion scripts and manpage are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/ripgrep-*/out"].first
    man1.install "#{out_dir}/rg.1"
    bash_completion.install "#{out_dir}/rg.bash"
    fish_completion.install "#{out_dir}/rg.fish"
    zsh_completion.install "complete/_rg"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/rg", "Hello World!", testpath
  end
end
