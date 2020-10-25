class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.8.7.tar.gz"
  sha256 "bc556de927c883efa6c377f29e602028b8960a62e5f1ba4f4a7403a83ad5b4c8"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url "https://github.com/kdheepak/taskwarrior-tui/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c3047698ed389e728e40ec9a018fe1cb7c5091d335a493a0e96c219fde522ac3" => :catalina
    sha256 "90794ef148cce47adb989df1e991a9dfa0eb9d70ba4bde55c47d616b55967a19" => :mojave
    sha256 "f3967c8cb4d440d321214537fda2bd03035929d4e6df7c06126d7997bfb42145" => :high_sierra
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
