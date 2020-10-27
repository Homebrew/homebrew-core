class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/v0.6.2.tar.gz"
  sha256 "2bdb5e013b0f4ff576c4c023c02fb8936661bde766f42fd07221cd2c9210c633"
  license "Apache-2.0"
  revision 1

  bottle do
    cellar :any
    sha256 "9d18c7b5ca1868526c6866049229106039799db8690d78487633d48c12cb7e3b" => :catalina
    sha256 "2dcb0f31b0038845d131b95252a885e43acbdb88b7a34fec260cb3077cfba6fe" => :mojave
    sha256 "1c661e58cc120d58b01e13b63a3012c2f17987ad643a1644601410880d8cbea8" => :high_sierra
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
