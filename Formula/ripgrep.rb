class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/11.0.2.tar.gz"
  sha256 "0983861279936ada8bc7a6d5d663d590ad34eb44a44c75c2d6ccd0ab33490055"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    cellar :any
    sha256 "db7aa040d1dace4cc4225493ca37802cf7c3769b26e3ed0d1cdd32780aeda252" => :mojave
    sha256 "d205bcd983c83ec1097523502d44598b844c3a13760e88449cd05b34e0ceba77" => :high_sierra
    sha256 "1212eb9d8a2a38bc54cbbb38cc92015c6572622324bdd049b3e016564a8571da" => :sierra
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "pcre2"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "cargo", "install", "--root", prefix,
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
