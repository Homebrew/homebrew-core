class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher."
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.3.2.tar.gz"
  sha256 "aea775c9ead5ee2b10b7cdebdb9387f5d6a400b96e5bfe26ccec7e44dd666617"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "80dcd354b2a5c1a905c1b5b2bd6894b195d535d94c3cbe08d1ec8a4c3f77e1e5" => :sierra
    sha256 "d53f7547fcfd68d434133ee533143e9da96ad34c274e5f14f3489f013b10f75a" => :el_capitan
    sha256 "3a88c43c13576a561d21c8257b8a7b696620bc844f2e10ba0aaf1ae7e0092ee5" => :yosemite
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
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/rg", "Hello World!", testpath
  end
end
