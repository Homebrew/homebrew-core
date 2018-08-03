require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.3.0.tar.gz"
  sha256 "4bfd8472fc2f2c73799c0aed1a134fa5a3f1bf30e01ded2f7063bb503d3e19e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "f42514a491af75275e0f4a5d94d9fac7a1e4f1bad1d218c94ff8bf4240c2c225" => :high_sierra
    sha256 "866d581c09b9a7788889766d4046c3dbc632370291435edb8d536bd1793aa8aa" => :sierra
    sha256 "59ab4332469478eef5c3053d376b76f4b45bf330ce5d2ac415768d4ec7fb77db" => :el_capitan
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
