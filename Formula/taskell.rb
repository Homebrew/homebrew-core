require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.7.3.tar.gz"
  sha256 "b56a70e821024e7d2aa9a5bd8e0336bd41995f0c1c99359ed72293d881a744f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5ec2e8dd37dc2c0ef123fe7b5520cedcfcaaae34d09204fb712753668862d5e" => :catalina
    sha256 "2fe3b24ad9631e26647106c9ab6b0a0b597491b21d37cc243b5a0af7e0e9fd37" => :mojave
    sha256 "3aecdf7cbd3b388f7a6e901b74a40aba050d851c194b83f1f1168b58460bac9e" => :high_sierra
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
