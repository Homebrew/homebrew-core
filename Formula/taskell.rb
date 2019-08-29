require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.6.1.tar.gz"
  sha256 "66f4b80c5f5a79f7f796bac7f24834879f30492dcf420041ea4f005bedf656d3"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4435d430a03be5fb76b1b1c02e461351525fb339b431a08c1dfc49817a76998" => :mojave
    sha256 "c8ccaf3b6230c5bf4940a9d34aad61623b94276791374799e8ed271266227610" => :high_sierra
    sha256 "00b0a4d4a69a0816dad8012954c617dfcb70fe340d2a40f5af8e075eef88e8ae" => :sierra
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
