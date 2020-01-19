class T < Formula
  desc "Command-line todo list manager for finishing tasks, not organizing them"
  homepage "https://stevelosh.com/projects/t/"
  url "https://github.com/sjl/t/archive/v1.2.0.tar.gz"
  sha256 "6620f6754d86cd245413645e8fecfb837ea5eb1209948b6e4031b25d1534b5ce"
  head "https://github.com/sjl/t.git"

  depends_on "python"

  def install
    libexec.install "t.py"
    bin.install_symlink libexec/"t.py" => "t"
  end

  test do
    system "#{bin}/t", "--task-dir", testpath, "--list", "test", "Test Homebrew formula"
  end
end
