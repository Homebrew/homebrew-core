class ScalrCli < Formula
  desc "CLI tool for the Scalr Infrastructure as Code (IaC) service"
  homepage "https://github.com/Scalr/scalr-cli"
  url "https://github.com/Scalr/scalr-cli/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "6276cda083f7c3c6d0f5b14809488f0dee93fdd40b43dd790e7927acfd3075a4"
  license "Apache-2.0"
  head "https://github.com/Scalr/scalr-cli.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Usage", shell_output(bin/"scalr-cli")
  end
end
