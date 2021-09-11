class TerraformProviderLxd < Formula
  desc "LXD Resource provider for Terraform"
  homepage "https://github.com/terraform-lxd/terraform-provider-lxd"
  url "https://github.com/terraform-lxd/terraform-provider-lxd/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "5ee49a14e336693477381dda40583c6f569a6d48263bd8b1a6939d74d2acd0b7"
  license "MPL-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/This binary is a plugin/, shell_output("#{bin}/terraform-provider-lxd 2>&1", 1))
  end
end
