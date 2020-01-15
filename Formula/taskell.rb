require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.9.0.tar.gz"
  sha256 "6b9fe5e411ebda99bc07cbd3ff49be450eacab13afcddfa2e7665957edeaf9a9"

  bottle do
    cellar :any_skip_relocation
    sha256 "0317e4516b7e24fa06db422f2a59f43a4827f816e9e827e6ad33d1a907fa88b9" => :catalina
    sha256 "c43e3ae3d3e74751e196eb56478d86c654c4f0ae51e6cfcf961c4e81ee24537d" => :mojave
    sha256 "2ccab5e5a1e9bf8e1899a59e953aa7d4adc2a72162267029a3061c4aea170d88" => :high_sierra
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
