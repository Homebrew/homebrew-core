require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.7.3.tar.gz"
  sha256 "b56a70e821024e7d2aa9a5bd8e0336bd41995f0c1c99359ed72293d881a744f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "baa3bdfa34942bc24d117265911acf485b2653d30419fd7b92e86eecf72e5d3d" => :mojave
    sha256 "5cefc442114d0e3f7bd06eb84285c6f61c5c6730b346eb80c02d72d21e552e5a" => :high_sierra
    sha256 "94210ead7c255058a381a46fee0bd06166737173e208b0ced933849950d4589e" => :sierra
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
