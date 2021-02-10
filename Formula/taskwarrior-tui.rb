class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.9.14.tar.gz"
  sha256 "5b1e8d397479b4b50a7535539a5efe991baf588dfca071c720e7d7d8521657ac"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "21dd86ffecabc669f44c785357aa35615f58d4d7381de6f9d24828af8eebc0b3"
    sha256 cellar: :any_skip_relocation, big_sur:       "a81d7b1e5cad67f33a8ed35141d9ea11349c78e823c1e03eea8c0a9c35ae5baa"
    sha256 cellar: :any_skip_relocation, catalina:      "9ab8aef9aef3e80200ef1e383370df4fe2097a17ba8e66e1d9f23c4690429e14"
    sha256 cellar: :any_skip_relocation, mojave:        "4f07a20f8fc8198dfd760cbae4b5d9aed9c72165302c3a60605724ea634f8b3d"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--config <FILE>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --config 2>&1", 1)
  end
end
