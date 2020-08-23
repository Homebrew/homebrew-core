class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/12.1.1.tar.gz"
  sha256 "2513338d61a5c12c8fea18a0387b3e0651079ef9b31f306050b1f0aaa926271e"
  license "Unlicense"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    cellar :any
    sha256 "60460d422253113af3ed60332104f309638942821c655332211a6bc2213c472c" => :catalina
    sha256 "de4b18789f5d9bc4aaa4d906501200ae4ece7a1971dd1b86e2b2d0a2c8e0d764" => :mojave
    sha256 "cfea5335bf4eccfb7cd1d93bec234d96bd49dce8d593ea966687f777909ba291" => :high_sierra
  end

  depends_on "asciidoctor" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "pcre2"

  def install
    system "cargo", "install", "--features", "pcre2", *std_cargo_args

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
