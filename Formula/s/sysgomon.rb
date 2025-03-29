class Sysgomon < Formula
  desc "Beautiful and efficient terminal-based system monitoring tool"
  homepage "https://github.com/samirspatel/sysgomon"
  url "https://github.com/samirspatel/sysgomon/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "75d77d161370496f8321560c2f89121c4f591a07119b13e141008a51a9c78666"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "SysGoMon version 0.1.0", shell_output("#{bin}/sysgomon --version")
  end
end
