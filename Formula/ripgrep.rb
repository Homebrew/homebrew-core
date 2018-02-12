class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.8.0.tar.gz"
  sha256 "c26391013522dfce3d870aec911fc602425e2eb385b75802b5b44440f4c32e24"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    sha256 "141f4a372665a161550835842cf967511cbad95487913fd28bb3fd87868c3755" => :high_sierra
    sha256 "5d41c5d4322357b2d39e00d24c37f4dec08fb3b4f2cd7d5dfd944627871646d4" => :sierra
    sha256 "8e183fb5763d350ae070756d3ff07e852ec624f6294d6657c067165328f7c6a5" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"

    bin.install "target/release/rg"

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
