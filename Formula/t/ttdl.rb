class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "ad952d458e987d87f7c73c5d646c83441f0626a750955eb7fcbe32f8a9848009"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aca4203e5caa4ff248a53e4f2e7024ddbafdd56df9a2c196b5eebe4d320733b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7411d1956a3bfd0453fd2eee84f434d5d3be68ce896122c01a671aa3946dd51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a31701449492322eed484d51032bc969744d8eb155b9e770d2dffe52bd1ed94"
    sha256 cellar: :any_skip_relocation, sonoma:         "e784775caf6b92ed2aeb9613d077d9cf11355f0e9141dcbd50c8e7e1612f7ebe"
    sha256 cellar: :any_skip_relocation, ventura:        "619b0937442ce44fce8989f134d65c303a6c2753ea3965c63f37f2ee607b967e"
    sha256 cellar: :any_skip_relocation, monterey:       "115215b05102d58725e371275cac661a64ae855d118bdd4b1b4a66e6bfc9550b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a85a83bcba6d5d253f2ff7ef77f82e985b8cd4a3ea6188b1a5989d5165b6922"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_predicate testpath/"todo.txt", :exist?
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
