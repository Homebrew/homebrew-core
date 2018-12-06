require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.3.5.tar.gz"
  sha256 "c1d0c5e8b1703f312e1150d1f121311898008d5a9d1dbb823df0bbc5e1b8b3ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "63d740bff025d90721e5884928e6070b530d8a09cca413487480545132311b00" => :mojave
    sha256 "29b60fee3c327db90ab96465bad5133a8583b6ed6cd89406f41041d795199ebb" => :high_sierra
    sha256 "8d5a18b033e871bcd82bc2b50b5519cafe6d6c9da65672a01deb665a3d1af825" => :sierra
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
