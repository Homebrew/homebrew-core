class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "d45c9eb79bda74fcd0b9fcfa7c98715ffb0adedc670797b60272b265dc7a67ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eef5173c86b3e8159b6ca44973320b3454526b3e7968c0da84163607e83b6cf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "456e237a2347d861545881d764f0c4c64814ad975f9ceddd443a5ec52b6de9a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a7b43d5920ca463569aa27b559a0bfc08a1d2bd252d1239178c527172b72c66"
    sha256 cellar: :any_skip_relocation, sonoma:        "411486fd9dacd7f962a68975f5ed395c0281efa401b43105a766766c9e9e060a"
    sha256 cellar: :any_skip_relocation, ventura:       "cb186a287fd2dd5798692ed1bd1e451aa28244622d64e4238785fe06b22f4b04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a5f7502be71d679856df7cccaf7ce955e7d3adccde772bc649e43fd6d2231f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "753a449b4306b775f4cc18ca01afd5cd846f5abcc26ebeef6a2d699a69730b4a"
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
