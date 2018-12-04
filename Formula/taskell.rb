require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.3.3.tar.gz"
  sha256 "c09e32621ad7a9e66b293be6eeef1e09ae53d20f48d34aedfe6de2a44938a131"

  bottle do
    cellar :any_skip_relocation
    sha256 "029bb4de3462225dbe8e867ea27c52f50ceb13976d1fa39f767eaf63c5160246" => :mojave
    sha256 "0bce1d76e6ac537f34e6cf98ab7456a73d0e305dcacddc402e5b57c130af1a54" => :high_sierra
    sha256 "93be8bd835d745cf76ba9e8d482265fe55443d806930c3d350b60252a77bd24d" => :sierra
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
