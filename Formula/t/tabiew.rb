class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "4b466e72a17e9dc9d8cf59a92398eba1fde361932bc644c2c1badc937fba0e44"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef11e7b97169d0843d91ea84cb2508720d5e14ea4244a273d1c8da823bd5b316"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6086e407d6e3e6f7fb00972c1e2b03d4b5c83e5eff56ca851d45f4c213bc981b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbc553069a5738242f2d8d592b758d8219f7a01fe6b9680845015884930d6389"
    sha256 cellar: :any_skip_relocation, sonoma:        "eceae1ef2d389972a3ef414b3bc0dc8f565e7bb93aa8c91d7e953ac0718525ea"
    sha256 cellar: :any_skip_relocation, ventura:       "afd72e67da0dcf5fd93fc5260ef97fd7d4301269c7c0d54cff82767d3bcc1b38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67ac5f2c7b85568c6c5ef28a79079e159c926c89908460ded52d7e007f932b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd5507813514018a791c355965e06f1b0f2fe79abec74158bfc3eab5d3591562"
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
