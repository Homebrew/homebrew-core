class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/v0.6.3.tar.gz"
  sha256 "5ddd180da79629ec36a26f7ff9caa39b5682c2f39e110f8e9c70d3a22b4ea125"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "3a2b4e58f0f9dd4437ea3ccc5c694d4854418663a96661f238d303ff0516f42f" => :big_sur
    sha256 "9d18c7b5ca1868526c6866049229106039799db8690d78487633d48c12cb7e3b" => :catalina
    sha256 "2dcb0f31b0038845d131b95252a885e43acbdb88b7a34fec260cb3077cfba6fe" => :mojave
    sha256 "1c661e58cc120d58b01e13b63a3012c2f17987ad643a1644601410880d8cbea8" => :high_sierra
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
