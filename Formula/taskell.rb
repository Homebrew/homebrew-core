require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.9.4.tar.gz"
  sha256 "8027af294eacc4e483a7dd6d8d510e10ae377510cf45ae1caf286b4022c5edd0"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5200196154ab64b1a13f30db9817404fb77f79711ff89baa9ce85847d445dcb" => :catalina
    sha256 "70b0634eb2c510398866d27ff49256055a0ec68ba26945e53991ba460970b862" => :mojave
    sha256 "ea408b6153f32196363a71c920c240b95d2fbc8d86de3c88e9d22afd645972e7" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "hpack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
