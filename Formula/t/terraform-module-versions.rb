class TerraformModuleVersions < Formula
  desc "CLI that checks Terraform code for module updates"
  homepage "https://github.com/keilerkonzept/terraform-module-versions"
  url "https://github.com/keilerkonzept/terraform-module-versions/archive/refs/tags/v3.3.13.tar.gz"
  sha256 "b85fbeb788c6fca0c328a29a1aab839cd556a7506105f544326a6e322d2aaf80"
  license "MIT"
  head "https://github.com/keilerkonzept/terraform-module-versions.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "570693949b4aeecf98436163b51c05af549c7100d35fbb07254fd8c9cb085d19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f120f8f70dfe4d25b7df6c6fb2469eeaf6bca263d732ad30397a7ec34e9892c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f120f8f70dfe4d25b7df6c6fb2469eeaf6bca263d732ad30397a7ec34e9892c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f120f8f70dfe4d25b7df6c6fb2469eeaf6bca263d732ad30397a7ec34e9892c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1f9c1efef4d6bd1de99676ca38f0d48df39201303c7cb5ef5171f013f51b9f1"
    sha256 cellar: :any_skip_relocation, ventura:       "e1f9c1efef4d6bd1de99676ca38f0d48df39201303c7cb5ef5171f013f51b9f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f97491547c6d3a1ce689aab8fcb4f8e4a0eb8bfccf4da2b0bce094806bda0ce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58972338b2b52cdd49510d81a228a18eeaa615d4ceec36cd35707dad896b0966"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terraform-module-versions version")

    assert_match "TYPE", shell_output("#{bin}/terraform-module-versions list")
    assert_match "UPDATE?", shell_output("#{bin}/terraform-module-versions check")
  end
end
