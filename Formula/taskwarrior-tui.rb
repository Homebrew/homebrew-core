class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.16.tar.gz"
  sha256 "242852c7026c74ec870c84920d2dc094bdcd1863828a342b4ad79525bfd98bc8"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4c58eb7badc69e6b677cf7c5ce1c39c7b56a20575ab2119dddb4d03f61fa6fb9"
    sha256 cellar: :any_skip_relocation, big_sur:       "e93defb0c81a169209aa55d1a5fc9ae48249fa7a463fb2f48e7a331b9e8d20be"
    sha256 cellar: :any_skip_relocation, catalina:      "e38c75b444c678f753ae7b921dace35012ef9e5c29b12bab143fcc52b939624f"
    sha256 cellar: :any_skip_relocation, mojave:        "20615c749bee880d3e03a57256dcdc1605fb06de67d19c8e44de985afce49ff1"
  end

  depends_on "pandoc" => :build unless Hardware::CPU.arm?
  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    unless Hardware::CPU.arm?
      args = %w[
        --standalone
        --to=man
      ]
      system "pandoc", *args, "docs/taskwarrior-tui.1.md", "-o", "taskwarrior-tui.1"
      man1.install "taskwarrior-tui.1"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--config <FILE>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --config 2>&1", 1)
  end
end
