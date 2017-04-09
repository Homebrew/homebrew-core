class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher."
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.5.1.tar.gz"
  sha256 "e0724d40f069580bac9f28cbf6005020fdc1b80e5d15fb69679d50ca341116f9"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    sha256 "11e832fed049bdc7510c822433b3d9d99bd0f421edac6610e668e784f493a549" => :sierra
    sha256 "1557bf41a1af55bdd47d4b9a1e0c625544f7eecb186e080163681d59614bf18a" => :el_capitan
    sha256 "e6163c0cd4473fa43c13cd2431d5c07b930913c2889b7975030eae192b0bc7c7" => :yosemite
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
