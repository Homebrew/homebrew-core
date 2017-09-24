class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher."
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.6.0.tar.gz"
  sha256 "102aff26fae9f455a8bcc435759d488f4944a34bee4b22b852f1cac3245b1b5e"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    sha256 "b98ba4360d7f14e419b165616b54f0a8b23f0044998fbfaf755c29c9a11e6445" => :high_sierra
    sha256 "7a63a0793714bf0924e5fd37ccce12c7a378e8ba147fe8703f907f906a65c1cc" => :sierra
    sha256 "550ede209cd469e0b30b029e57b6efa37372c223c7767e20d5ec0ed971366e2a" => :el_capitan
    sha256 "f8bcc372a72fed2db3954acaa589f110bc3f58f4475618bd4345fd94e0ce82c1" => :yosemite
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
