class Taskell < Formula
  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.10.0.tar.gz"
  sha256 "c78c74c2d3cc1c0608014f32fc788f03cae79e0761aeea8e6701101d75526101"
  license "BSD-3-Clause"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "d5590cb08683d0df90ae9e13dc2059d1b4fb25adc6641d2a11518ae7f2b1798f" => :catalina
    sha256 "6e5d96a506ed0708e03de2c8addf294059c09c63790f93020d0ea4a5c8f06358" => :mojave
    sha256 "8f2534b0801b19657a2351bd5e36cf4f747f807431f61acad94fb02c310eda95" => :high_sierra
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
