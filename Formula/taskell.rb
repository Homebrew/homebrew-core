require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.5.1.tar.gz"
  sha256 "24f0cafa515a0551e03b1596ef65d93c82e743ec8a690b91b482691f14f6b4c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "22d57069a1c3d33e5772a4b437d87b5e28178af04a021b5faca38f90c4ad5906" => :mojave
    sha256 "59fe1e957d17dc2f3ce93936ee57313ae03ed7a447797328346b34a2f0876703" => :high_sierra
    sha256 "f542ae2d07dbd9ebf9ca1ff5ecd9134413c6c9327d5493ceb44d3359c096520b" => :sierra
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
