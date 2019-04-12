require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.4.2.tar.gz"
  sha256 "3f5457f0a20bb9d4d68abdf676e71163f681cde5e707ba29f0a09ed26a76377d"

  bottle do
    cellar :any_skip_relocation
    sha256 "56dacd9606d6f3020ccb7b10f0ab0a7579ff7d6a2aa19f2214b6db97e37b8670" => :mojave
    sha256 "68a1ca216931427ee8c60b31c41461c5af64aab42936a9681714aa6b8dea29d6" => :high_sierra
    sha256 "05b2816ed0148d4360d2d294ac18c304f20f4e573cb2ba035e7c4a6f9740035a" => :sierra
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
