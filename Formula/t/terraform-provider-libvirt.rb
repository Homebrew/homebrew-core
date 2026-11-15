class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/refs/tags/v0.9.9.tar.gz"
  sha256 "ac862a6eb4a9aeac94bf61a3f1eea6f1a3854b01bc75ad2f0be19847b9dcee7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ecf2ea570063ead11059953492b9f30bb1f487ab32699a76e308fca2279fd4e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b4d7d9e3a013173b18c0fdd592b1cadf2a95537d530def466b3928fd9be571a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b4d7d9e3a013173b18c0fdd592b1cadf2a95537d530def466b3928fd9be571a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "2b4d7d9e3a013173b18c0fdd592b1cadf2a95537d530def466b3928fd9be571a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7c3f8dc493d2694dc239f4a3d4041aa37392cbc7e3dbef75f486dc5d7b12656f"
    sha256 cellar: :any,                 x86_64_linux:      "f346f7fdf0492086389b01fb749c3ba5f41ac918ba0d407db2daf95a941e1edb"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  depends_on "libvirt"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "run", "./internal/codegen"
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    assert_match(/This binary is a plugin/, shell_output("#{bin}/terraform-provider-libvirt 2>&1", 1))
  end
end
