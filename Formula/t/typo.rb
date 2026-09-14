class Typo < Formula
  desc "Command auto-correction tool"
  homepage "https://github.com/yuluo-yx/typo"
  url "https://github.com/yuluo-yx/typo/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "ee1e2d5ccdfb0ccfc09530c880e096013c3301f905dd455d9f24636d8c2f3839"
  license "MIT"
  head "https://github.com/yuluo-yx/typo.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/yuluo-yx/typo/internal/cmd.version=#{version}"
    system "go", "build", "-buildvcs=false", *std_go_args(ldflags:), "./cmd/typo"
  end

  test do
    assert_match "typo #{version}", shell_output("#{bin}/typo version")
    assert_equal "git status", shell_output("#{bin}/typo fix 'gut status'").strip
    assert_match "typo", shell_output("#{bin}/typo init bash")
  end
end
