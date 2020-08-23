class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.4.5.tar.gz"
  sha256 "538152806b030a27d81824fe1319203d0ff27f7c3487faf0cbdec2097aec6909"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc15fd956ef932aca1ea71f708e3825426d72d4d1de22f792f635f23fd7d58b2" => :catalina
    sha256 "a02a7621b1dc51132808e15af97ad598dcaf10b0aa20c9c140adf2b7e1a9eca6" => :mojave
    sha256 "1de5ece489498a95029d1740daba354fee2da5f955561fc67804ffcfc629b7d6" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-ldflags",
           "-w -X main.VERSION=#{version}",
           "-trimpath", "-o", bin/"rancher"
  end

  test do
    assert_match "Failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end
