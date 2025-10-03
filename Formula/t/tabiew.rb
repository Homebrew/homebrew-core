class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "da3b74987f318471aa9701a80deb69837be82df9c9308f4380abfb26df2abf79"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6bd1b2dbb9ac3e7ad069e1125f9e17368f2e85a6f887772037d6a53bedb47d23"
    sha256 cellar: :any,                 arm64_sequoia: "e1c27e0718dd472be14f51e58d56bd08854c5f97923be23fe9a77de930305231"
    sha256 cellar: :any,                 arm64_sonoma:  "0fb4cd270519ff8c1b470aaa18f23f64c9b0c4c38698001345d7e32dfcd24205"
    sha256 cellar: :any,                 arm64_ventura: "06556b8ff92c18611451060c5ca6ba3441b90bf31a53b61ca9ce4705b52a359c"
    sha256 cellar: :any,                 sonoma:        "ca433890032f62f4e49995a401d8460a55a1202b70a7b709283b0cea273b850b"
    sha256 cellar: :any,                 ventura:       "b4a4baa0102dd4abc3cf871f10152d2585913e85f4c71b6bb3f161a2f9150965"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f71cf83e2cf034bdc1215039c5888ce591a69daf0508d08cc47bda3075244615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6533aa32a5da1e32d851244d7661063147a020a70c2b76771f3e3c7616be9453"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  conflicts_with "watcher", because: "both install `tw` binaries"

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "target/manual/tabiew.1" => "tw.1"
    bash_completion.install "target/completion/tw.bash" => "tw"
    zsh_completion.install "target/completion/_tw"
    fish_completion.install "target/completion/tw.fish"
  end

  test do
    (testpath/"test.csv").write <<~CSV
      time,tide,wait
      1,42,"no man"
      7,11,"you think?"
    CSV
    input, = Open3.popen2 "script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin/"tw test.csv"
    input.puts ":F tide < 40"
    input.puts ":goto 1"
    sleep 1
    input.puts ":q"
    sleep 1
    input.close
    sleep 2

    assert_match "you think?", (testpath/"output.txt").read
  end
end
