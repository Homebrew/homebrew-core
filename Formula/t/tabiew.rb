class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "7f10c6d07ea84e28f2c3b8312ce7f65dc32236a61d9de441817e1a279b5437e7"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5648ef89aa3cb551a9580302c74d779a260f68b7e833fad4f506efe693f088a6"
    sha256 cellar: :any,                 arm64_sequoia: "f8a33c7ee147a4e4c0917b4a5ee6e526d3c4587269c6dccc7ef1472335802463"
    sha256 cellar: :any,                 arm64_sonoma:  "98a958f0baf55e15443f9dba8e6b5e1df181784d59d3e10c008a195ce9c892b2"
    sha256 cellar: :any,                 sonoma:        "6603d0ac91915d22c21ea9683019c4c0d8a17155b57944554deb017cddba666e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0929ce152b00a8108eda93033d38b08973aa55cc6d3cb787088ee3221379d62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12d805a4b38057a66fd15f26dff9b006b8fce4c9f9bfb6b6aa2cd275224c3cc0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  conflicts_with "watcher", because: "both install `tw` binaries"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix
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
