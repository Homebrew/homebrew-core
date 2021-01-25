class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/v0.6.3.tar.gz"
  sha256 "5ddd180da79629ec36a26f7ff9caa39b5682c2f39e110f8e9c70d3a22b4ea125"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "16ae4512f40a98056d05c21077bac05f96a6356e17362bfcff28e3649548f254" => :big_sur
    sha256 "d9b1288e730298acd13c72661eaab16cec9d1f435032f9a3d12340910a6cb85a" => :catalina
    sha256 "9d54585dbad9de738460f1cf773aefcf1d557e5edadb1e245f8cf618edbc6152" => :mojave
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  depends_on "libvirt"
  depends_on "terraform"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=#{version}"
  end

  test do
    assert_match(/This binary is a plugin/, shell_output("#{bin}/terraform-provider-libvirt 2>&1", 1))
  end
end
