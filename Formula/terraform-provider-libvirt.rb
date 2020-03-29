class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/v0.6.1.tar.gz"
  sha256 "3562070c22bda0f38c44fbef88f345e08a22a567bccc56f7a25eaecc6400ee36"

  bottle do
    cellar :any
    sha256 "7b458aace029d7bbdf3eee429253a3ae8259372a24c6fc4a069f2088cf6d18cf" => :catalina
    sha256 "ff697a12beb2941a68bbeb641ac13ce9acbff6f8380521e41370f3727bb26ae9" => :mojave
    sha256 "e853e165d278c60fce1287fbf4207802ae4f57280cc90cec2cef3b55ca587bc1" => :high_sierra
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
