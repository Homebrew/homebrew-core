class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "08c94c1e531b53c99d9c1a3f7e9960337b869cfdf85fe547afdb1b3c9a6233d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29bc2f0daf42d093054cef911e80e6ff6da0b6eea96d158c0451135799014ad3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7cf91d8888ca58d1e3cb0423e2380ccf365f2d17603b93ef07db00b83b0878f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "965ee15895b913290d89c4a56a8feb695e10fedd42bb27c978391ac1efcb38bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2340338678343c8e736ed0764faf5d957c6d0ee59f1d6cbec2b8b6ee498cae98"
    sha256 cellar: :any_skip_relocation, ventura:       "3423f700e05347b9ab64d78cc0b3f255653efe88a9790f1c3cee81b40907e3c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08676f5bc49b7658feb2a9ffb0f37bb423479a56837b64c9541363a45e5f6f3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7243440074aa412b5fccd6e7457ef9e1cfa28258a41eed8129ca315724011250"
  end

  depends_on "rust" => :build

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
