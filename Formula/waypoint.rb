class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.8.2.tar.gz"
  sha256 "2df379dfb119e93baf2a946414181b4f9ae741412f5178a2fc43a2425bb70a84"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "759c1791fa50bb15c7f270d7d8d1f7621b17d23f5c6d9785d9c04341a2fc1ead"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29f515a429801627bcdd80619e4a9161a257512b9b846ac85a4b43842c66001a"
    sha256 cellar: :any_skip_relocation, monterey:       "ca07c300dc1ddc403d823b19557b875db85c89d9b0ade0f3c5ef87bf675ba321"
    sha256 cellar: :any_skip_relocation, big_sur:        "2dae6f6dae2616f06e42e327cad8e7dcdf762cd7e37b512bf1fd709b55eda1a6"
    sha256 cellar: :any_skip_relocation, catalina:       "bb7e85feda880189e66e0474538da43a182214028318d20a17cb4b7db2c0af5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54a6b50395ccedca823a14536363877e8352711735d4918cbcb8ce92d1d8d5af"
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
