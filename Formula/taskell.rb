require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.3.2.tar.gz"
  sha256 "f3526798f585c1f8fe2b7a4968f0f531bd37356069b4ac3e6a8c049f17ed893c"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a331422682572a2cd295bf1c9ce21dfb909b17fc4f46a074e58913bee71f4f2" => :high_sierra
    sha256 "1f1925525a3fa8cbf16736cf12c4c221222eedcd34275ad3154b6fdaaea8c29b" => :sierra
    sha256 "e7986dc9b6054d47fc25e9bbcead451d65ce3971c5e5eb6ea2a2268bcb1f0bb6" => :el_capitan
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
