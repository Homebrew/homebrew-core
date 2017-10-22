class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher."
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.7.1.tar.gz"
  sha256 "e010693637acebb409f3dba7caf59ef093d1894a33b14015041b8d43547665f5"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    sha256 "c40c41348fcea9cdc695730ac316960a0640505bd8d38a86397851e3f9309337" => :high_sierra
    sha256 "5a0d45fe2bce48002f65b867c973a85cd54e83df2f942da64037aa71157a9e7b" => :sierra
    sha256 "e7ca5276c76c581d2e95a1d6a0d8408abfe552f5352a9888602cc994a16afed4" => :el_capitan
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
    zsh_completion.install "complete/_rg"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/rg", "Hello World!", testpath
  end
end
