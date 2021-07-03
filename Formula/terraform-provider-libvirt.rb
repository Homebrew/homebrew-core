class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/v0.6.10.tar.gz"
  sha256 "c98a552f09a93760fb2be850b381f26f6ac07eccbbd0503921f13469bf849667"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8a3e7b264374f3b33a26f1570d49b33c167281c7f6bace4a3454b68fd9939c8b"
    sha256 cellar: :any_skip_relocation, big_sur:       "93e9512035534d0eaa30dce1ab16858710d3cb02cb2d1ae55ae31ae1fde41ccf"
    sha256 cellar: :any_skip_relocation, catalina:      "7d265367cbc9794528e39740a24d5ba77ca4fbcc11f578aa3be687c844165a13"
    sha256 cellar: :any_skip_relocation, mojave:        "a72d40b7e0d6fd286f28e4e584b8c8731fedd43710345cd679a70c24e0e1b745"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  depends_on "libvirt"
  depends_on "terraform"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match(/This binary is a plugin/, shell_output("#{bin}/terraform-provider-libvirt 2>&1", 1))
  end
end
