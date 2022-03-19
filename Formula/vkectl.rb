class Vkectl < Formula
  desc "Command-Line Interface for VKE(VolcanoEngine Kubernetes Engine)"
  homepage "https://github.com/volcengine/vkectl"
  url "https://github.com/volcengine/vkectl/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "15f0f3786c03d53702306ba4ae8812afe59e0094356d1202c292cca87242ac77"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b448a0543341c7f1e85e5348d4870e863abd6f1bcb336e67251e7b166fb7c5cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "777027b5b9c97203ff135ad143f69578cd04395df4ffdff191cb370b64df246d"
    sha256 cellar: :any_skip_relocation, monterey:       "b4d4672f1f6f879dac715753429379de492bbecbb60ea963c8e3343bd053c108"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed46bcdf4004aef00d92ae0caae727a2c66caf39da08423276fbb0f2a5880f74"
    sha256 cellar: :any_skip_relocation, catalina:       "d00a281f29eef8ec8f0a9772d94b9e6b63937984c2d5bd8be74a11c9a4a6e29b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7369d566f5a8d7701bee09d76174a2145bcd7b1601311f20484e2f96fb0fe5ea"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/volcengine/vkectl/pkg/version.version=v#{version}"), "./main"
  end

  test do
    version_out = shell_output("#{bin}/vkectl version")
    assert_match version.to_s, version_out

    resource_help_out = shell_output("#{bin}/vkectl resource -h")
    assert_match "AddNodes", resource_help_out

    resource_get_addon_out = shell_output("#{bin}/vkectl resource GetAddon")
    resource_get_addon_index = resource_get_addon_out.index("{")
    assert_empty JSON.parse(resource_get_addon_out[resource_get_addon_index..])["Name"]

    security_get_check_item_out = shell_output("#{bin}/vkectl security GetCheckItem")
    security_get_check_item_index = security_get_check_item_out.index("{")
    assert_empty JSON.parse(security_get_check_item_out[security_get_check_item_index..])["Number"]
  end
end
