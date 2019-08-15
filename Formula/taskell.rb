require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.6.0.tar.gz"
  sha256 "5033252318bfb3b81a090b3a6063b19eb03d896c4425a2923a5af7d2b19306ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa9e5e45f4a80ab1b9c1ac8b483a9416aa295da5c20e127a99e2245dd37cd7dc" => :mojave
    sha256 "c259424717e16109518f3a1a13695892b1f221fba2dbd9985a0d96ce26eb2184" => :high_sierra
    sha256 "4128b2dba1114854573304a44312297ad5efbf4603ff531c9489c29582650772" => :sierra
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
