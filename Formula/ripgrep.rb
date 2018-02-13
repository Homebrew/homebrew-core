class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.8.0.tar.gz"
  sha256 "c26391013522dfce3d870aec911fc602425e2eb385b75802b5b44440f4c32e24"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    sha256 "890607b3d4006d95ff8edf6f3ae00a2c85832555b49b540d451c9a9a5b56fe54" => :high_sierra
    sha256 "ca2b6de550843dbfbe71909a119f0f07c15e3b85b076d4daa7d1818b33e6f848" => :sierra
    sha256 "3bd8b954a7022314699fe0f9fd6687707a21584bd4fb61a4019505a95f70c540" => :el_capitan
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
