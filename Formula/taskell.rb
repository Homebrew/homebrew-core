class Taskell < Formula
  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.11.4.tar.gz"
  sha256 "0d4f3f54fb0b975f969d7ef8a810bbc7a78e0b46aec28cc4cb337ee36e8abdfc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bc36ad8fb97691d0adf77baf9261a43e7847792f97b9438a7680b0517d6b15a7"
    sha256 cellar: :any_skip_relocation, big_sur:       "525c5a78802f51d6190b37da97c59c6137dda23aef8ad178f72d4db56b8ed3ea"
    sha256 cellar: :any_skip_relocation, catalina:      "4fcbd4fad2ba404104ad3252d14de4a3ec71e7d7533e1b75a2885afad1a68418"
    sha256 cellar: :any_skip_relocation, mojave:        "5afca666e495be65c8bc8f690d90876bb32615946810b580107f7824c5bd8ad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f1c183a626bbce99bc4dcb75ddac69537d69ec2592b19c366005bd757d2a1c4"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
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
