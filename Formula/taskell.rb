class Taskell < Formula
  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.11.2.tar.gz"
  sha256 "315cedc1e4d0a88427af9aaa738c700ff98c0ae3a419b39e01dabc1c5fcd6c81"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9fad32c49602fdb5149a64a0ae7dce11f3d0cfd3c8a955df86322fc4ceed78a2"
    sha256 cellar: :any_skip_relocation, big_sur:       "c95a88da66c6183220d8ec6d7894eba3be90a9b6a84b0164dca643ec1815e0a1"
    sha256 cellar: :any_skip_relocation, catalina:      "714ff7f48235b81bb89b9cdae12513e9c4667622bd00423f8f9efa5715d34efa"
    sha256 cellar: :any_skip_relocation, mojave:        "cfe418dcc1fc8858d25cc1b83a71a4bbb37d82c7c541b0a487c72fb629f4f035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbd5cd50b7b69021a0d8e1cbec409027ea92f7c032559bd0bd07056189945ad3"
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
