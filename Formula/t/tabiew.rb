class Tabiew < Formula
  desc "TUI to view and query delimited files (CSV/TSV/etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "ec8907e5858a4610b26c38f663760810700c88430b5327b067e0ce8922ae7ffb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0c4822f18b2a6abd00fd626baf7cd5421167ddc439f0216262e400606bfb1546"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55ca7131fa5d7bf5d13667f02e44b90fdf9725904fe49a9e1ff1fad9928af755"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68abb217914789bbeadbb9a8f30093631a1b2f41d136ba223db40e91152b0e46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62cea35186bfa27cb5cad58d3d7930bea44cd75acf3c3e83ba6421e036e8ee4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "161a1785de5ca1cfa87d22fcd69a1638b8d2b93c4415f93e6351b686f85f525b"
    sha256 cellar: :any_skip_relocation, ventura:        "98bbb9e668e1af5beba44d4e517fbe1c32b7a59cf1275032cc456c0bb9d56a26"
    sha256 cellar: :any_skip_relocation, monterey:       "198ac14968a5ed36f93b44b8a08cd3e55f233626131cf4bcc6c88a3d98165332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b10d12b07b4d7899c7915fb971754b63f3161d3bb30e2cf728f9f0f757330800"
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
    (testpath/"test.csv").write <<~EOS
      time,tide,wait
      1,42,"no man"
      7,11,"you think?"
    EOS
    input, = Open3.popen2 "script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin/"tw test.csv"
    input.puts ":F tide < 40"
    sleep 1
    input.puts ":q"

    sleep 2
    File.open(testpath/"output.txt") do |f|
      contents = f.read
      assert_match "you think?", contents
    end
  end
end
