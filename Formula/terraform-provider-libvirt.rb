class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/v0.6.2.tar.gz"
  sha256 "2bdb5e013b0f4ff576c4c023c02fb8936661bde766f42fd07221cd2c9210c633"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "a554630fc5120ecfd2c9d95cde9b5d86c245c56fda9a388664633d61ff20dd5b" => :catalina
    sha256 "106d4cefd9b03629bb1b5576208b5f19b911a10a0e6ef50e29d498ef56461b59" => :mojave
    sha256 "0c3d7bace6f2fc3c76bcbb3f4972402446e9fcb5a40d2d99d04f5eacedfb7943" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  depends_on "libvirt"
  depends_on "terraform"

  def install
    system "go", "build", "-mod=vendor", "-trimpath", "-ldflags", "-X main.version=#{version}", "-o", bin/name
  end

  test do
    assert_match(/This binary is a plugin/, shell_output("#{bin}/terraform-provider-libvirt 2>&1", 1))
  end
end
