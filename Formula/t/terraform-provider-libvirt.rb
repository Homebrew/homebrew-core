class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "15b929d2eb4e64ae4bb26939789ca40e753c3b2847eee7992fcb4dd3b5df83e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93d3deb14e53e36982a0e742ba130b45db6bee2cd56275065653bf815a60edba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93d3deb14e53e36982a0e742ba130b45db6bee2cd56275065653bf815a60edba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93d3deb14e53e36982a0e742ba130b45db6bee2cd56275065653bf815a60edba"
    sha256 cellar: :any_skip_relocation, sonoma:        "540a2810e36e21b0678e9fe2f073e52eac134468295ec570246e065983a8fefe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4923bd412008553c38bdfdd9cdcde24969e10708e1fe2a17d1836a758e58057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7c92b04207dbec3e02233dbd6b54187d90fb61c77b66557c277754f038b0a34"
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
