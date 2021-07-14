class Taskell < Formula
  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.11.1.tar.gz"
  sha256 "95fdaa7bc263f8ade47399a49d9175fe885e297e4c124c4cf68347ff063a715c"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "099eb4452b9addf669f80528aafb535c2da0b54f8ff96338c9c2de793dad57df"
    sha256 cellar: :any_skip_relocation, big_sur:       "c295e3baa31965d1bf983efef6caf99c646a86d0a9c6566d818f43688f2d6cb1"
    sha256 cellar: :any_skip_relocation, catalina:      "9836cdf38c84e87446dc020c397291465b780c3ae1f89eecdb993369f196b12c"
    sha256 cellar: :any_skip_relocation, mojave:        "7c997322a2675e39457a1d4884bbf44d4721df57e8608cda93f4dfd5ecb730d9"
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
