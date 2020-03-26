require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.9.3.tar.gz"
  sha256 "bbe81d4a8f04ca6bde0ef6c18b5cc29730e876ea40b0c21a8dfe9c538aa39235"

  bottle do
    cellar :any_skip_relocation
    sha256 "98306d1b63e79984e6d4329cfa83cef8e648cb9a6245113946612fea85ff9af5" => :catalina
    sha256 "42f5e2adb3bd30b4477ec40bba2e26cff5192ad43bc8e9341abf909c925a8713" => :mojave
    sha256 "93e7c89aafc04ab9e0b99d28b951ae30403e349fe986f323cdc07d9eac3baada" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "hpack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
