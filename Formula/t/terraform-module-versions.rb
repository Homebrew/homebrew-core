class TerraformModuleVersions < Formula
  desc "CLI that checks Terraform code for module updates"
  homepage "https://github.com/keilerkonzept/terraform-module-versions"
  url "https://github.com/keilerkonzept/terraform-module-versions/archive/refs/tags/v3.3.10.tar.gz"
  sha256 "c84e947c26741e4c95d9c0e0a5e7d01d41ebcdf7bbb85b0106f1013b08e20b05"
  license "MIT"
  head "https://github.com/keilerkonzept/terraform-module-versions.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d813ca4e8bc2426d3b3ba8f1c373fc915752ff4553b9d46034a6be95942d1cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d813ca4e8bc2426d3b3ba8f1c373fc915752ff4553b9d46034a6be95942d1cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d813ca4e8bc2426d3b3ba8f1c373fc915752ff4553b9d46034a6be95942d1cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6f0f314bddecfd6dc337353bda79132f8b2de124ecb4b45ffe67dfc94601570"
    sha256 cellar: :any_skip_relocation, ventura:       "e6f0f314bddecfd6dc337353bda79132f8b2de124ecb4b45ffe67dfc94601570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ba49288a639cab0d6c07ccea353c5b67caf6d31de44f9d242813427e67e711f"
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
