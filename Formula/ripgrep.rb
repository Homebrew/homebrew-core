class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/13.0.0.tar.gz"
  sha256 "0fb17aaf285b3eee8ddab17b833af1e190d73de317ff9648751ab0660d763ed2"
  license "Unlicense"
  head "https://github.com/BurntSushi/ripgrep.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e0147ba489a8d96e33fc8be7e2172c632075d5d31a4f6267c3606e463280e0e3"
    sha256 cellar: :any, big_sur:       "0ca7397f9a0ccef6cbb8ff0fd8fb18c6fe86219abaef350e3d7ef248d07440fd"
    sha256 cellar: :any, catalina:      "60460d422253113af3ed60332104f309638942821c655332211a6bc2213c472c"
    sha256 cellar: :any, mojave:        "de4b18789f5d9bc4aaa4d906501200ae4ece7a1971dd1b86e2b2d0a2c8e0d764"
    sha256 cellar: :any, high_sierra:   "cfea5335bf4eccfb7cd1d93bec234d96bd49dce8d593ea966687f777909ba291"
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
