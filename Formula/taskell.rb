require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.3.4.tar.gz"
  sha256 "7cdbc1ad8ff8f144348a74051998013f4b585610e7e2517867047e02fc4a3d3a"

  bottle do
    cellar :any_skip_relocation
    sha256 "2bd2be9d7be3e33148ac29b13cfc65977403ec8f769b1b4b85a54a11bc252296" => :mojave
    sha256 "7439e13ac3367461d243d822eabd0d7ad781759ed118378a25b08e461b9756d2" => :high_sierra
    sha256 "c30059dedf17741bfad4e5d7f4864d5279712532a6f6f3e503ffba3c29b3e4a9" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      cabal_install "hpack"
      system "./.cabal-sandbox/bin/hpack"
      install_cabal_package
    end
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
