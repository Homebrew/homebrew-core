class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "3f6a4ac06362b8223e738d9b9293b80b1607f1b98b45b44ac70b438106c0f9f5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6b61cbc31bd548f18f54b84ef44de05406a346c84438a28a91a7031f21cf4607"
    sha256 cellar: :any,                 arm64_sequoia: "621adafa19bf7eb9bb79f1cf9bc9782617336e29894ce48df14c5cb4add0c715"
    sha256 cellar: :any,                 arm64_sonoma:  "3b3b3a0f6fc3cf5876e558e4521e860ad0884c937532dee3667331a41f2eb9cd"
    sha256 cellar: :any,                 sonoma:        "f06c6a25998b63e4c19b366b3622b092a09e006bac6ace8f187008cf92cc3b7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7317a0f171d14e2c8d56d8fc06a2cbfb80c4478fb7ff05e3b68f3433d00ad5ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3bd0d9aaf6d158e86f77f2076dece818aeacda582f81749f4bef27c605b0dbb"
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
