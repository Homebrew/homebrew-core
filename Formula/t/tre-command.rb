class TreCommand < Formula
  desc "Tree command, improved"
  homepage "https://github.com/dduan/tre"
  url "https://github.com/dduan/tre/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "280243cfa837661f0c3fff41e4a63c6768631073c9f6ce9982d9ed08e038788a"
  license "MIT"
  head "https://github.com/dduan/tre.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61124e9bd9782b9ddfa36f838995411afa0d901063b33eaf25e527c5e63b7b8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ece0114a11a6a7358aa4465613c05ea48a12b002bc425cd08ce3ed0d86c24b30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b56a1c935f7283cbcc876a004a120e05dc88697238d85498043455f9cecdb36e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da85ee4f6a66a56b10372a9e6702ff9cb63574543780b65ff71abaa25efdf223"
    sha256 cellar: :any_skip_relocation, sonoma:        "88227f6cdf34f1809d7bd0a8fc413c03c2256c6d3eded62e835ae4280cac3cbc"
    sha256 cellar: :any_skip_relocation, ventura:       "5a5d538e52db0c9136ce286ff233e845a3aeea9746796d3e0c449c6d19f71e57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66386309ee18528d98fee3a568613dcc7d37b9992fc29d0fe10868b3d679a9c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb6a971b2a393fbca9ae0823891e7da696e1436f2261619f3fee3c1b7d455c4a"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath/"completions"

    system "cargo", "install", *std_cargo_args
    man1.install "manual/tre.1"

    bash_completion.install "completions/tre.bash" => "tre"
    fish_completion.install "completions/tre.fish"
    zsh_completion.install "completions/_tre"
  end

  test do
    (testpath/"foo.txt").write("")
    assert_match("── foo.txt", shell_output("#{bin}/tre"))
  end
end
