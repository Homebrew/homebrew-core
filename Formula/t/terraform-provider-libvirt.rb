class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "94b859477830e8d0d7a6a8a0fa5ac714b714e114d90242d2a285dc3b4905a03f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7534297d3ea162905a226070dc91e179fedf6b4da25720d1fb86f335196edad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7534297d3ea162905a226070dc91e179fedf6b4da25720d1fb86f335196edad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7534297d3ea162905a226070dc91e179fedf6b4da25720d1fb86f335196edad"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b6bbd38ee00e6e94934710258e438bb4d5aebd744342b91259657b08eeeef22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d2177750f88f092cf8f1f399b11aa1c538f18bac8aafa046bc55918c7a50afb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "788f8f2502fab6e58e51ceffd8de25c5aad7a95a77c7e024d572fba5e7364e76"
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
