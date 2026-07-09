class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "ceae42a8ee138ee8742f173ae127f783c6d28c836f07e7ad2e859033e45224b9"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7e08204952d5664bd02c981bc5d6d1a4c21d6ee69d986a1baa53b00ef781f4a5"
    sha256 cellar: :any, arm64_sequoia: "08725701e4ee397bf84428103f31d44064a88f2f30378f61085d75bff82c8edc"
    sha256 cellar: :any, arm64_sonoma:  "aea1502321a209adab0c8d385d65bc9feb61002b245694d64003e7369d45c930"
    sha256 cellar: :any, sonoma:        "025c63768b0c88f7c76e0d5d6c3d29bc02db00a4ddd1f274334ce7005170aa15"
    sha256 cellar: :any, arm64_linux:   "7bb4aa6ea6572a05296d0d809ef938654101f4897e284a35c18b83627bc31a4f"
    sha256 cellar: :any, x86_64_linux:  "0228d3bb2cb0ea2aa6633b797a07b26f6a286226d05e2675b655edd9e23bdabb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  conflicts_with "watcher", because: "both install `tw` binaries"

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
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
