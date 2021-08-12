class Taskell < Formula
  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.11.2.tar.gz"
  sha256 "315cedc1e4d0a88427af9aaa738c700ff98c0ae3a419b39e01dabc1c5fcd6c81"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f66b603b952c5fd17a3bf591026b0b77becfe3074f7972c2841f41397d6d44b1"
    sha256 cellar: :any_skip_relocation, big_sur:       "5db71fac3febdad0e6db5387ad101b1bcec0522ebaed786bd5dd41be1193c76d"
    sha256 cellar: :any_skip_relocation, catalina:      "600617501023ffa7d3ad29eeebbd1df33eb988c68c8ea68be916c02621096550"
    sha256 cellar: :any_skip_relocation, mojave:        "5f58cebbefb99c775b9c4e87aecbaf7157dc8552bef97bab6efb720078e57ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "320df073c22b4ef1b5b7405f7dee0c2b7bffcb28f44d5afacf33bb6412ae15e9"
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
