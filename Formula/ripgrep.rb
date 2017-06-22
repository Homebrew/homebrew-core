class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher."
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.5.2.tar.gz"
  sha256 "5d880c590cbb09d907d64ba24557fb2b2f025c8363bcdde29f303e9261625eea"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    sha256 "cb81327bd6f3eae5abc3ca0e445c5ad1c1051c5f56c71504478ce21927a13d3a" => :sierra
    sha256 "2267c6a6bcad614c5c96709e50829de6a77d0c8c06e488383801aa5d21262949" => :el_capitan
    sha256 "0a80a55397476474d0e33daad3966407c0f84cd504bc8aad4c944c7144a03bef" => :yosemite
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"

    bin.install "target/release/rg"
    man1.install "doc/rg.1"

    # Completion scripts are generated in the crate's build directory, which
    # includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/ripgrep-*/out"].first
    bash_completion.install "#{out_dir}/rg.bash-completion"
    fish_completion.install "#{out_dir}/rg.fish"
    zsh_completion.install "#{out_dir}/_rg"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/rg", "Hello World!", testpath
  end
end
