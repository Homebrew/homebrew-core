class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "2b9c63eb4036812482bb17ad4a22443ab0127e1438e071bc8f45454b8e50c91a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4967f4e067a0542778062e0129bdce844b79f2d30bdef80b46630ee86fad282f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4967f4e067a0542778062e0129bdce844b79f2d30bdef80b46630ee86fad282f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4967f4e067a0542778062e0129bdce844b79f2d30bdef80b46630ee86fad282f"
    sha256 cellar: :any_skip_relocation, sonoma:        "eca3fdd64be5178d509ea077fdcfca04737ec6b77293c5972b065a2921b41576"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e48e05af1008a897baf0c8d87e5a8d4d9738837cddbf571faf3e054acf9b0a0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bbb8f44333b4dfcac7bbe657b0f1ea838250bbd40a5699af6f66f402c4f4624"
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
