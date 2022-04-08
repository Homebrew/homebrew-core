class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.8.0.tar.gz"
  sha256 "8a068481a5985285ed25e96ad6983c0aedf4a2c27934f19095bcb8d2641d571c"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d49182a24743c6dad030bbe6e9b263fbc4f51a2be994931f397adad2e506c10f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffc8af52200e105a282f5a50e84f2ae17c3b34555a0dcef7dae0ed347cd4e3b6"
    sha256 cellar: :any_skip_relocation, monterey:       "589971eb383c34c3dd1c241eb27f5cf4f816a187a1c7acac8afecd3cd1485943"
    sha256 cellar: :any_skip_relocation, big_sur:        "08f2898fc1799ba6059e4b44ffcf6489ebb018c732dce036f3f01a6d9e74cabc"
    sha256 cellar: :any_skip_relocation, catalina:       "2a63b32836b81fed556233eb8b75eee068b5733f867a50cc99a6b6cf491af892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "631c8263daf7c276541291d4da73d4ca6766b90726e8e93c022622b252a58e84"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "bin"
    bin.install "waypoint"
  end

  test do
    assert_match "Initial Waypoint configuration created!", shell_output("#{bin}/waypoint init")
    assert_match "# An application to deploy.", File.read("waypoint.hcl")

    assert_match "! failed to create client: no server connection configuration found",
      shell_output("#{bin}/waypoint server bootstrap 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/waypoint version")
  end
end
