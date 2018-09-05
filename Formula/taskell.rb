require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.3.2.tar.gz"
  sha256 "f3526798f585c1f8fe2b7a4968f0f531bd37356069b4ac3e6a8c049f17ed893c"

  bottle do
    cellar :any_skip_relocation
    sha256 "f91a550bb15dd832776e86b33eae16b2956b93e7b741dadd0468963a7d988c7e" => :mojave
    sha256 "cee86ae14a02377bbdad3561883d7b3dbe8542cc624a0675663a66e4b32508ea" => :high_sierra
    sha256 "ecbf13ef7e552db7018eeffd94df291c27f1d5175264d400567a430d3b564692" => :sierra
    sha256 "a7d7886bc48bb6a6c9ba8152b08e89e323c002be98b55eb03d6357b7db0500cb" => :el_capitan
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
