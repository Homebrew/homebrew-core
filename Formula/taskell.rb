require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.5.0.tar.gz"
  sha256 "4bb27d6ccfa93d37350a58fca66332e694d6d722571f504ca235ce5fe3956c37"

  bottle do
    cellar :any_skip_relocation
    sha256 "86c3605cf37d04617f6db0ff165d17817ad0379a1dbbd1addec3ab692910cbff" => :mojave
    sha256 "be0d352ef92c4908cc4044e91fc0f5baa86b1c0443dfb32653986445773228eb" => :high_sierra
    sha256 "38fc57dd5ee868f5342261ca3570a9e1ddde9c14e83559309ead3b8914a7c648" => :sierra
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
