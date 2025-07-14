class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "9d04ca75d7cb3db511ea251369890d1bdf2a6b7d77c4d4ce5d3cb0d2c0214252"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4965933e5ec39c5f04ae18a08828df9e0dbbda8f7d80d1278c4951493fe9d15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4965933e5ec39c5f04ae18a08828df9e0dbbda8f7d80d1278c4951493fe9d15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4965933e5ec39c5f04ae18a08828df9e0dbbda8f7d80d1278c4951493fe9d15"
    sha256 cellar: :any_skip_relocation, sonoma:        "15e9fab3f999c737143ad9c66ff18fb3861f17035636179d3ffe752fbb120933"
    sha256 cellar: :any_skip_relocation, ventura:       "15e9fab3f999c737143ad9c66ff18fb3861f17035636179d3ffe752fbb120933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42969edbf2abbbba627cf3bd855e749aba8a2cbf570e5da9fa1a45a912444374"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  depends_on "libvirt"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match(/This binary is a plugin/, shell_output("#{bin}/terraform-provider-libvirt 2>&1", 1))
  end
end
