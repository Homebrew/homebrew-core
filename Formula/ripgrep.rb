class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.10.0.tar.gz"
  sha256 "a2a6eb7d33d75e64613c158e1ae450899b437e37f1bfbd54f713b011cd8cc31e"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    sha256 "58dbade0b798fdddb8991e5dde455f33344a94908ed2ec4f58849d4bbc0e5dc2" => :mojave
    sha256 "230255cce6e94ea67cf16dbbc088bcaf8bcdc2b281fbee67e6c2c24ba86a2c17" => :high_sierra
    sha256 "f13a92e0c9172e7534a4335f78a1a3c757490fe7c8792565a3bf546a2ad06cc7" => :sierra
    sha256 "6835a77967b13fbeabdf8d7e43023bcd11c6b7360d88ab18694d4650f9002339" => :el_capitan
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
