class Vkectl < Formula
  desc "Command-Line Interface for VKE(VolcanoEngine Kubernetes Engine)"
  homepage "https://github.com/volcengine/vkectl"
  url "https://github.com/volcengine/vkectl/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "15f0f3786c03d53702306ba4ae8812afe59e0094356d1202c292cca87242ac77"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e97c5fc11ed6e59b18406768e61e59a5d07197cbccf05877fdb5c533e89481b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42ef174bc73b1d72b1ac07339f103b636da4131b11ce155936314f4df7ccea7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dde1dccb53289861944edd98bd291ff3e307d4f3ee9f8c3fa0a5b54e9f5b957d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93da7d4e85a216bb6a4167023c27d5ed0c50acdf82912d3283142b4a410f4216"
    sha256 cellar: :any_skip_relocation, sonoma:         "5648074c8c8b10e5bb97672917aaf76f3c18d20213c08f4ebd12d62073af46f9"
    sha256 cellar: :any_skip_relocation, ventura:        "cf2334adc68f3d83cd581d03ec214a8be3e951a80da6e474de37f6915d415d45"
    sha256 cellar: :any_skip_relocation, monterey:       "b15fdb3760570404c00443899dbf5215a9d0a89cb8d23f6eb16d866e0e1b7f5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a613ea0176b98d6ff76168412fd78fba623cc85b719c23d57301fe2b403eed00"
    sha256 cellar: :any_skip_relocation, catalina:       "e13380eb084651d7a1b6d515cdb6e9cc781d25b0d1293e49642dd6b4d7e20ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8642891d03c1b70b07f60f69492f8b104097508ca84b41f53c157c47853d78b"
  end

  # github.com/choleraehyq/pid@v0.0.12/pid_go1.5_amd64.s:28: expected pseudo-register; found R13
  disable! date: "2024-02-12", because: "does not build with Go 1.18 or later"

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/volcengine/vkectl/pkg/version.version=v#{version}"), "./main"

    generate_completions_from_executable(bin/"vkectl", "completion")
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
