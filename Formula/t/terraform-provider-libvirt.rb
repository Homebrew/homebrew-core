class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "a200169400d0a7d8a181f756f7c3a7504107829d228de29ae101260249b322aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c7d51ae333cb9afbe6148142916d4b0f373f7738413c1ae7fdf4d09feddef57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c7d51ae333cb9afbe6148142916d4b0f373f7738413c1ae7fdf4d09feddef57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c7d51ae333cb9afbe6148142916d4b0f373f7738413c1ae7fdf4d09feddef57"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0aa5766be44a043eecef11b3a409d2e55a823bb72fddc82e5c79e3b257bc791"
    sha256 cellar: :any_skip_relocation, ventura:       "d0aa5766be44a043eecef11b3a409d2e55a823bb72fddc82e5c79e3b257bc791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbf450b3d09a1c6e7a7afabf5eefef2e03b292ae2ea2a0f597f342735d4efb26"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  depends_on "libvirt"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match(/This binary is a plugin/, shell_output("#{bin}/terraform-provider-libvirt 2>&1", 1))
  end
end
