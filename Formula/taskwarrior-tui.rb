class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.9.0.tar.gz"
  sha256 "591ed30332ad9fab454437666be43bb040b58a1814c5d78c142976b8d0c72027"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url "https://github.com/kdheepak/taskwarrior-tui/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "49a3143f0735b215a57af9a8afda9ecd8bf229b75fd1ee56aa59bdb0d110e392" => :catalina
    sha256 "84e8c8055f6f606a6b87dfe2db2ed1a94cb5c9e8de4ad42141428d018745394d" => :mojave
    sha256 "be348fe5fdd6c9ce910aac3b379ce357e0c471e851d74cc117373096c768ad3b" => :high_sierra
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
