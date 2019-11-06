class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/11.0.2.tar.gz"
  sha256 "0983861279936ada8bc7a6d5d663d590ad34eb44a44c75c2d6ccd0ab33490055"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2807391bd15f5529d15c88357b6a54de405ea22272a81613bb53bcef0c40717d" => :catalina
    sha256 "e8916c30f1eea952b2429c1268a7f91aa19178e56c97106bc71f53778d2084aa" => :mojave
    sha256 "2e28d6ebf756c5bd0d952d885166b39d5f1f19a10421a66f722fc5a22ad206a9" => :high_sierra
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "pcre2"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "cargo", "install", "--locked",
                               "--root", prefix,
                               "--path", ".",
                               "--features", "pcre2"

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
