class Tabiew < Formula
  desc "TUI to view and query tabular files (CSV,TSV, Parquet, etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "cd425757c0785fd15a95602bcf15f2c77a178a209e672444299123904cdc6617"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75b76daa68c049a2f8f718ad5b782c3e15d783deb31b9e37d27afb2d04f67c0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4ed66e655e73c99ac554769e9f80f35dd76cd40b5e881632a9e374141f128e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76205e84f0fea12fd4ae8adf81433c603cf7acd048b2c35b096a0175e1978dc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "de91468e225837c165bcef8b9bd03c093c2bcee6730caf41067d54979a3139eb"
    sha256 cellar: :any_skip_relocation, ventura:       "9c842c783af69856fc54cb6d9467297f6ee25343bf9c24dcd6d39f9e03b76403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75de8126438c18ab0f62915091cd190a708cddf7941302a5e9424bf669e39044"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "target/manual/tabiew.1" => "tw.1"
    bash_completion.install "target/completion/tw.bash"
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
    File.open(testpath/"output.txt") do |f|
      contents = f.read
      assert_match "you think?", contents
    end
  end
end
