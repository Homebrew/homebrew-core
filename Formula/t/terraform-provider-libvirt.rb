class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "66aa32c45c98fdc2d20cda17ed01e82c1c7d9ee7c7849e5757391a31ae5cb5cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "445eab723bf380802dd92fde008ea7009a9b11e154f547b7231088d24708fff0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "445eab723bf380802dd92fde008ea7009a9b11e154f547b7231088d24708fff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "445eab723bf380802dd92fde008ea7009a9b11e154f547b7231088d24708fff0"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf3348d66abd387cedde4bb59de96f228aac6f934dd518bd0f1e2cdf4150e340"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e47a2251bdcec63f176f62afe5bf6c2074bb77e60c9b91fe0edabede3494ddde"
    sha256 cellar: :any,                 x86_64_linux:  "23e62acea542c0c32228d79d2c53dd5e8a8ef6a7df91b1ff0f9549869d0a3522"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  depends_on "libvirt"

  def install
    system "go", "run", "./internal/codegen"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match(/This binary is a plugin/, shell_output("#{bin}/terraform-provider-libvirt 2>&1", 1))
  end
end
