require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.4.0.tar.gz"
  sha256 "6edb07a5ed1970ec3948f9281027e473c87884624e815a9a535b3539578b9969"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7cab6bc815dd3586be8226d7bf9d60b110cdc14090e3d989bf0963736eca672" => :mojave
    sha256 "0ff5307191258f84a2af4cfa15cdb6e21125c878cd1c501d5bc9cb4674c47900" => :high_sierra
    sha256 "20e738e349e62877e8492200af2f9cece04aeae31175b05c193eb93c809af57f" => :sierra
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
