class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "133d6151e38b4b2f796cbbb3f4a701796257969f5bf6edb8c26c9881167841e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3721beec06c80e73489ca404100442939fc583d73522fd615456463b120aa94e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c9866ff993cfe21bc35d7918d2240c6a90dca204ee6ba77e3d45a27b2b22303"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44faaa1b33fb6b2dd1f00fc0e75cec45559e378e9a73d9efc4a4930427efe729"
    sha256 cellar: :any_skip_relocation, sonoma:        "6874d2cad6c98543d9dad174eb1b42cf322bae91db7dd7061fe1a561f33cc4ac"
    sha256 cellar: :any_skip_relocation, ventura:       "928505025725e834e59a1cf911673c3fc3c945aad98e8a624a80d45bcf9d51ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "446257cef745cdc4b991f524edc836aa7c5b155b11e8275866bf65f2268173a7"
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
