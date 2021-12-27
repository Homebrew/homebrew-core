class Vkectl < Formula
  desc "Command-Line Interface for VKE(VolcanoEngine Kubernetes Engine)"
  homepage "https://github.com/volcengine/vkectl"
  url "https://github.com/volcengine/vkectl/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "899a3c913f78a1442ef6e8afceba34cb36e842464388609ffa228e3a1514d208"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/volcengine/vkectl/pkg/version.version=v#{version}"), "./main"
  end

  test do
    version_out = shell_output("#{bin}/vkectl version")
    assert_match version.to_s, version_out

    resource_help_out = shell_output("#{bin}/vkectl resource -h")
    assert_match "AddNodes", resource_help_out
    assert_match "AddVciSubnets", resource_help_out
    assert_match "ListClusters", resource_help_out
    assert_match "CheckCidrConflict", resource_help_out
    assert_match "CreateNodePool", resource_help_out
  end
end
