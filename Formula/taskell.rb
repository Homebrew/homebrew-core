class Taskell < Formula
  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.11.0.tar.gz"
  sha256 "870a8cd5d7e9366a05b3289e86ab9999b7a5193cdf38d09f83bd8bdb3ae74a24"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "e61c059369ca603626eb2eb196d7f13d9796a5e7c1ec2ccf4b8ed848138807cb"
    sha256 cellar: :any_skip_relocation, catalina: "87d75501a9fa9a36b4e4e5c10d056a7b62419a697399272e18fccda61056a1ec"
    sha256 cellar: :any_skip_relocation, mojave:   "d31fedb601fbda5ebb84c9c05208dda2d2fc2312b21b981fad97ceb40ee7c4e6"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "hpack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "hpack"
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      ## To Do

      - A thing
      - Another thing
    EOS

    expected = <<~EOS
      test.md
      Lists: 1
      Tasks: 2
    EOS

    assert_match expected, shell_output("#{bin}/taskell -i test.md")
  end
end
