class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher."
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.3.1.tar.gz"
  sha256 "08618425de89bdcd84f17a3bbf71a2d00a787de1f196e048059c01969065154e"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c01b699c06411cfaf5abf506950b9307adc1479e7943980694b8ff02c5e67b63" => :sierra
    sha256 "1c8a0025a68e8879751fdaca2b2f70ce1e538b62c4ed2f5c0fb0edad295ee01f" => :el_capitan
    sha256 "70a123b6254a752f8ae87420bd07384a0cde8340d866a354e83af4c1b4dcd127" => :yosemite
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
