class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "e115f589921eca6205341cf5f44af4c0d3bb0b5b9583eceddfaecdf21a0f243d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f049a3920adde5444a7258ccf966140b4b459281122ed2a89cc16f24cf827edc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f049a3920adde5444a7258ccf966140b4b459281122ed2a89cc16f24cf827edc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f049a3920adde5444a7258ccf966140b4b459281122ed2a89cc16f24cf827edc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a05d947551acdd17426a3c3b73229afa16032d4efd52ec98e8e15515e04d96e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bf39ed0b6e46e3a829b2dbb99ac5342d91369d90446da070315737eea292214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1a08c48fc3b3bbfddd49b521f9b2d216b06a6fed7e30c5900fac4261d98ccd0"
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
