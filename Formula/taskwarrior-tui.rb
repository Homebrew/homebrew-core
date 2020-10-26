class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.8.9.tar.gz"
  sha256 "d2f5f3fcdf5c3ac1823115f8bd4db8ca6a2806d864d20aa9ce473f1937c2acc9"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url "https://github.com/kdheepak/taskwarrior-tui/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "aff9a5b1cf547809e3560ce06c69ea6651b4dbb94eb2edf1311627c14db73ce3" => :catalina
    sha256 "ca0ea89471fcd46151b3451b93608263203d505e3df5c2cd9073a9eedd99bded" => :mojave
    sha256 "4891537a01a1766e12897703066e91d1aaa5a82d73bc0c69120748c9d5dd9be4" => :high_sierra
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
