class Taskell < Formula
  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.10.0.tar.gz"
  sha256 "c78c74c2d3cc1c0608014f32fc788f03cae79e0761aeea8e6701101d75526101"
  license "BSD-3-Clause"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "aefc0644df5856cfc6906ca934a196500047d0b7ad224c8c94a75dfffb7e0f80" => :catalina
    sha256 "b0319a89770e4b6aad95945a20a1043aa89aee8fc23f83e0fc4e60d28f0ebe32" => :mojave
    sha256 "0ee2351fb87af22ce38288389132e990faaa81a2d6d392f711386dc66142393e" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "hpack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "hpack"
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
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
