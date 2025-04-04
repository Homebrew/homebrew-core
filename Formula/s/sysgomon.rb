class Sysgomon < Formula
  desc "Beautiful and efficient terminal-based system monitoring tool"
  homepage "https://github.com/samirspatel/sysgomon"
  url "https://github.com/samirspatel/sysgomon/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "e7a5412de43c39790c916e9ba142f552482635e57d9832bc6288698b7b04b447"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "SysGoMon version 0.1.1", shell_output("#{bin}/sysgomon --version")
  end
end
