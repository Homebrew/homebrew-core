class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.8.1.tar.gz"
  sha256 "7035379fce0c1e32552e8ee528b92c3d01b8d3935ea31d26c51a73287be74bb3"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    sha256 "fb489281ab4b9ef78bbd8213588821e9b8c77c67b4a029d95fd70e402e55385d" => :high_sierra
    sha256 "e3dde96a13ac740dd2358c2ecd7ff34e2c71beb2abaeae16996cf6686a65996f" => :sierra
    sha256 "b02d84ba4a1dfb9570927144366ce5501231a081d3400d0d8bddaa4e39c17e53" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "rust" => :build

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

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
