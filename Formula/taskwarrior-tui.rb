class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.8.10.tar.gz"
  sha256 "965888e227bae667c6a12e096294d47b9bbf41a0b9561c0bc98e7cacb389e4e9"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url "https://github.com/kdheepak/taskwarrior-tui/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ff135587c48f1b8b6fec9b821be348fee6846bbf891acab497d7ade36c2ab229" => :catalina
    sha256 "eed9b1901091d55fcbb3c21df25647c050af2b31c89efa85e1598f6f697bceca" => :mojave
    sha256 "bfc7206ab141d156329d2dc2542e626f3373108a2009b4f142f13505a10bd013" => :high_sierra
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
