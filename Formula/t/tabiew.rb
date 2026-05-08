class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "7f10c6d07ea84e28f2c3b8312ce7f65dc32236a61d9de441817e1a279b5437e7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a0c7d9ba4698ecc47d76eb457036761dcc971097d3d508617dbb154b2fc27536"
    sha256 cellar: :any,                 arm64_sequoia: "d766e5dbbd65f992f83d312791ba91b445cf1defd6c89107ecb828598b673a12"
    sha256 cellar: :any,                 arm64_sonoma:  "b46d9cf46a8b21eaf89965521c3783d27d7f3920040e73b8207bdbf375ddd87c"
    sha256 cellar: :any,                 sonoma:        "e75ddca15ac27beffaa898fed3bbf2e49e0179be61aef4a1b0f38fa9993c6970"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4f1ec9edc8e462600500866d0d2d8c00280d68a775ca23a760fc7d04a7dfc25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f9bee3520c0690e2ad865dd7e55cfd9eeb26ef9f1ecbd62427c3c56d3aa8348"
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
