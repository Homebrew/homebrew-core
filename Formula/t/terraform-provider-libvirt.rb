class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "e547e2b46a18a8796fd91283f474fc4f8ccc494ea054f43fca3c3e8cea9c7ed4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18472a60f9650b88e63baf0ba21b8f23bfb9dcefa99de62480e80dcb400d43ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18472a60f9650b88e63baf0ba21b8f23bfb9dcefa99de62480e80dcb400d43ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18472a60f9650b88e63baf0ba21b8f23bfb9dcefa99de62480e80dcb400d43ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c31d906856e49b220b8a6552aa0cde06475cf8c99a94187f97865cd1f99ee60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d09976abcd3353a491cfd48be50e468860057ea9071277a36bbc01e349c4a64f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1eecc198d9755aef2edd626259ebf2f354e4d142154cd20e9d9ca24c271ce0d8"
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
