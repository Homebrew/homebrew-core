class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/12.1.1.tar.gz"
  sha256 "2513338d61a5c12c8fea18a0387b3e0651079ef9b31f306050b1f0aaa926271e"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    cellar :any
    sha256 "2166ad007897bd17af541ee32a799cc022153712989bb054ab31c3b3ff187faf" => :catalina
    sha256 "a379bb5c1370d4680654ba7db02366f3f6773204bb26f32c23b11891db85b4c3" => :mojave
    sha256 "c275e581ab2f5ccf3a93c085f7915d1d8699df5b5aeec5d84b398651a2a836b0" => :high_sierra
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
