class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.7.tar.gz"
  sha256 "e69dd7dc1b185fd6c51fc6c787a7ddae3ca55409c829de2e742a4ed93bce08a6"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5fac07d1d2d55bbe5b47c30125e99230a2cf699d6d427971da9e76cd322b5207"
    sha256 cellar: :any_skip_relocation, big_sur:       "2e56eb136905487868c1eeb0e275668ff53404e8d33cf930f3b9473d52cd49fc"
    sha256 cellar: :any_skip_relocation, catalina:      "f7c45f38be108b5acdf63f2ae36e3a74376e7775b479427390272d3a92e3def3"
    sha256 cellar: :any_skip_relocation, mojave:        "1dab7f0e996332eed5c67b75461bd1e2e52afd28642b4a2da9fcb76179310015"
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
