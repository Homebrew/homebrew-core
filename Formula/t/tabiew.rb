class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "912c45cf26d83b96a0003c0134c2971c82cbdf2dda630fa8fa11e41c4ce28150"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f55b4fa7f134115b01bba141a3ac58ecffcb7b7162c89729e1eec1d44837108a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e7ec10c3b14aabc55eaa6c5239da79100cbe673eb552a8f7b09db8569c83b8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09b84a0bde191d419be974b78fd6cbbe5b291579418392a495b773abb0ee18f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1af34fbbd32732ef6c60e731f217cd3e75f0ced2edc4b728b2db2044e547d16"
    sha256 cellar: :any_skip_relocation, ventura:       "1d27866c282863c2d6135f009dd67affaa6e6545268a5c078260aa71f37f9eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dce88d9d2b6081e9d637447d6e7fd3e92c8850aebc97d20afe5eda9619fdac5"
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
