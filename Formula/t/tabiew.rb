class Tabiew < Formula
  desc "TUI to view and query delimited files (CSV/TSV/etc.)"
  homepage "https://github.com/shshemi/tabiew"
  url "https://github.com/shshemi/tabiew/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "2f7e13e27f0e8cf7c9b135d1c7480a65b6ad86c3f984205854051c6dbbeba97c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "698d37ca8431554bf917e7415131918c80de7a59571d61cafe767b223acdf6df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbc4834021cc5a32e6cc5a8c174f72cd542cc04b8735363f8fcec3809e593f96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd5c5b28ee6ba41f4253f33cf56845804f8c0adebd97d5f596265b93da225bb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f205e50646a8bdae380baa2995ab202c04283864779f0b45912405a5a93c721"
    sha256 cellar: :any_skip_relocation, ventura:        "4c901b5e2432abc55cfa0c16ae2c7f67bd7585784cb0d7a5aa792c02418528c3"
    sha256 cellar: :any_skip_relocation, monterey:       "008762a8c910b68b2e64d59e3aab4d5d6089c4d7ff76256fd7ee637f52cbe191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bee9e3571da7a9c1bf515bbdebf46e6c666a4d8bf629db1f39442bdc407b2cb4"
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
