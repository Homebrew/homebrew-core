require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.2.6.tar.gz"
  sha256 "ffd2028ff18b08dba2a890b3e7d76d20a1f78698416d5061274ad062140a5731"

  bottle do
    cellar :any_skip_relocation
    sha256 "795675c556107f84c6ae99a71e188d085057339cf166ddc32e22cef791fcaeb9" => :high_sierra
    sha256 "64d03382c764d54621641e76dd03926161b19fcf6714a0ca69514d9acaee83a9" => :sierra
    sha256 "05aea1a72bfb1012d46c0bbf01c9b4943f428550000b2a9bd2c8d1e4e66c42f9" => :el_capitan
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
