class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "a1deae7e912493f89223e19c017d3e38ea17f821b00e9213c4506dc503242a2e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5fe26af0d775f7f38e58a4af2cd5c8a9877bd5c9e745dda6fc9b200066d41bfa"
    sha256 cellar: :any,                 arm64_sequoia: "dc4771f858152520fea4fffebd98814ec95b444cced99c0e740726fbef08dd8e"
    sha256 cellar: :any,                 arm64_sonoma:  "e86594ad0b1e26c4b7a373bd8092bbf364747a43748bf8c66256caf4caa9bf91"
    sha256 cellar: :any,                 sonoma:        "168ce86a9420304295c58ed81f8bd0940dc8ab18b93d14896f3a11c913dccb0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab43c2c430f32bd4b400f0f60c671937f257e70dce5feb62acbedaf9aa1b4226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2593655526975484ea5ad31526ce5e1adb57b6a9b701fe1f837cb66802329420"
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
