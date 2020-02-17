require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.9.3.tar.gz"
  sha256 "bbe81d4a8f04ca6bde0ef6c18b5cc29730e876ea40b0c21a8dfe9c538aa39235"

  bottle do
    cellar :any_skip_relocation
    sha256 "111fd4a43d0dd5053517872aaa1fdf8cceb24b212ffa422e580db44b93f3a37f" => :catalina
    sha256 "9e18af03b8c6cd94d01724f6d7247f48b92c73c11eb0c14176ce5ade0d0f47a7" => :mojave
    sha256 "78819149a4d0cd8e528d64b4b37ddc9f98c2a1aa56c0a223fb062b8be06530e3" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "hpack" => :build

  def install
    system "hpack"
    install_cabal_package
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
