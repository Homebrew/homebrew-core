class Quran < Formula
  desc "Print Qur'an chapters and verses right in the terminal"
  homepage "https://git.hanabi.in/quran-go"
  url "https://git.hanabi.in/repos/quran-go.git",
      tag:      "v1.0.0",
      revision: "2558e37fc5be4904a963cea119bb6c836217c27b"
  license "AGPL-3.0-only"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "src/main.go"
  end

  test do
    require "pty"
    stdout, _stdin, _pid = PTY.spawn("#{bin}/quran 1:1")
    op = stdout.readline
    stripped_op = op.strip
    assert_equal stripped_op, "In the Name of Allah—the Most Compassionate, Most Merciful."
  end
end
