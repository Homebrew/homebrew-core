class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher."
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.5.1.tar.gz"
  sha256 "e0724d40f069580bac9f28cbf6005020fdc1b80e5d15fb69679d50ca341116f9"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    sha256 "ae11f7184b49d756e32a3d9bf4ac17aa083e90cf8011433dfcfa968a0f23d2ef" => :sierra
    sha256 "11a04d4397af3b992f2ce9faffdf0efed04ef6e341af8b74284e7c64e9a44585" => :el_capitan
    sha256 "b6afa53155c9cc4cebb55bf14e8f00cc7db645c2b5edafdd881585403af7afdc" => :yosemite
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
