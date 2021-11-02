class Semv < Formula
  desc "Work with semver"
  homepage "https://github.com/elgohr/semv"
  url "https://github.com/elgohr/semv/archive/v0.0.3.tar.gz"
  sha256 "93cba19e8c727ed9704ac4bbf12a5b4c6c19290fcae0ba6292fd2c573c6ca3e2"
  license "MIT"
  head "https://github.com/elgohr/semv.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    system "#{bin}/semv", "-h"
    assert_match "1", shell_output("#{bin}/semv compare 0.3.3 0.2.1")
  end
end
