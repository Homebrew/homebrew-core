require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.4.2.tar.gz"
  sha256 "3f5457f0a20bb9d4d68abdf676e71163f681cde5e707ba29f0a09ed26a76377d"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed76d25e8962de2c8f79d8682400420fed2cc6c8c6c6159c4eeb2e1b2864feb9" => :mojave
    sha256 "3f3114ae21c2e0693a685785498469a184b42f717a6b7ec25ab3f7bcc3c0b24d" => :high_sierra
    sha256 "5487a58e2e18c2f80a525fc8da9d3b5ef7a13b14118806b37a01213411b1022e" => :sierra
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
