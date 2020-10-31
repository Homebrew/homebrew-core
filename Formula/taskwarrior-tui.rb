class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.8.13.tar.gz"
  sha256 "c63ff0e2e404d3ea6b1621aeb803f462f6ec2e4256b840f850b8f0ba5909c47e"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url "https://github.com/kdheepak/taskwarrior-tui/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4860d4c0ca61d0347cf75dd8699927e8f69aaf5cf7c818fa574171b45258f574" => :catalina
    sha256 "052ff0a9346c19ef528973e96cdef8794fecd9d2e2816964901e0267553cd5d4" => :mojave
    sha256 "79fcc82c2e0a64837180251828dc34357a90105f869badba2a46fa15cabea614" => :high_sierra
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
