class TerraformModuleVersions < Formula
  desc "CLI that checks Terraform code for module updates"
  homepage "https://github.com/keilerkonzept/terraform-module-versions"
  url "https://github.com/keilerkonzept/terraform-module-versions/archive/refs/tags/v3.3.12.tar.gz"
  sha256 "5cb38a014559e17bc125728381e29f4ed92264df0f651d5ef783cdad833966e4"
  license "MIT"
  head "https://github.com/keilerkonzept/terraform-module-versions.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4617f15006d80c603e3b3b57e6f5dcce8b19b8cda78a10b6709cfa5290a2f1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4617f15006d80c603e3b3b57e6f5dcce8b19b8cda78a10b6709cfa5290a2f1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4617f15006d80c603e3b3b57e6f5dcce8b19b8cda78a10b6709cfa5290a2f1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "186a2d05ddcf4a40a294bd76ca5fd3b9b9da60e39fd16a4d337d23e690b2d30b"
    sha256 cellar: :any_skip_relocation, ventura:       "186a2d05ddcf4a40a294bd76ca5fd3b9b9da60e39fd16a4d337d23e690b2d30b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "024bf6479175a7694bd93cd0ef7a118167f63b2377dc6a4cd1534d2c30e75311"
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
