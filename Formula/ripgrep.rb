class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/12.1.0.tar.gz"
  sha256 "ca2d11dd7b7346734d47ad8073468e9c409fbe85842a608d372b8d4fb36be291"
  revision 1
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    cellar :any
    sha256 "da6e16cfdce8be20d2b5168358ead7c4c274aa2e295ae1340b05e05629ae9d10" => :catalina
    sha256 "01b887b190a0461671d8b5fb6f580cafc53899c86d742615342184b70c179ae9" => :mojave
    sha256 "be49cef17dbf58a02e02f45d062fd833424280e7b9402332186603397c1573c2" => :high_sierra
  end

  depends_on "asciidoctor" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "pcre2"

  def install
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
