require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.4.0.tar.gz"
  sha256 "6edb07a5ed1970ec3948f9281027e473c87884624e815a9a535b3539578b9969"

  bottle do
    cellar :any_skip_relocation
    sha256 "1eb4f86adf6091bd65d5299eccf2ba4f52895be1bff0a73cf420f6853433c884" => :mojave
    sha256 "b69e4374545751d9b2a0c2d9b8ee306f1a165c45627aa6143f0197b247b7a13e" => :high_sierra
    sha256 "557a5d3731d4c721a0e26002818cfb2af97c3e022dcd283b9a6f61d9771e2360" => :sierra
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
