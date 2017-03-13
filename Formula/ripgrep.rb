class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher."
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.5.0.tar.gz"
  sha256 "8e210c7486cfb2a782cb0aab0c5eb7c1fae606b4279254b491a084c8da84c11d"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    sha256 "12d64b716a235f1826cba7ad615a55c68c1179c64138b1b0e1aec5601204b76e" => :sierra
    sha256 "2e89fd19fd99c09f0328328310d8bef03e4190e98200e87d6aed35a13831b8c3" => :el_capitan
    sha256 "ab72bd1f61995d0c2000db95c84bd08d4d6959639cf8c0693be51ef76d62aab0" => :yosemite
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
