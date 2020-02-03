require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.9.2.tar.gz"
  sha256 "2cb633013a35bfb5cced81fc132a6789a3c69d32e8f4aac820ab266f6fc2470a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f54b52233d7843b4d2f4ce6c2187a266bbc78129c31968054c97c3dde25a087d" => :catalina
    sha256 "3b088dbd935d07efecc919ea0a6154c5f1c146e7c8ed23569f32d7351af35067" => :mojave
    sha256 "49078ae4e663deac24cef2b5d780d44535b131145695f82cc4b1f05e9e8a4e4c" => :high_sierra
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
