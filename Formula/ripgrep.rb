class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/11.0.2.tar.gz"
  sha256 "0983861279936ada8bc7a6d5d663d590ad34eb44a44c75c2d6ccd0ab33490055"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    cellar :any
    sha256 "780e74bc09f13e5ac6a38894cf46e6b09e3ea0e1d5b24bb8f516f7c395363edf" => :catalina
    sha256 "8a9673593698833a3e79407423c549499c2096c206f2309baf3a6a1fa58bc83c" => :mojave
    sha256 "e0f43c540165eb7c181328c9e18a28f9fb65ca6e178a2d898915760c212bfcd6" => :high_sierra
    sha256 "3bb6e27a3adaf94129c18491a552899a354ce36846ec2a849ca5ad40e848ad62" => :sierra
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
