class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "6bb585f384ebc9a250ef06ebc15bc8232abe5c074a0221e32665ef6f79c2a73e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc12facb3daa95ad2287892fabf6525319609cb4ccc875b7913725b75f836aef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc12facb3daa95ad2287892fabf6525319609cb4ccc875b7913725b75f836aef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc12facb3daa95ad2287892fabf6525319609cb4ccc875b7913725b75f836aef"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a1e7b09bde735780521766f372e5bc88db11ce3ecc6ab57ffe1c33b73640a65"
    sha256 cellar: :any_skip_relocation, ventura:       "3a1e7b09bde735780521766f372e5bc88db11ce3ecc6ab57ffe1c33b73640a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbd985adb0f773bd08c7b4e3775656baa01d7867c3dbd7fcbf475b6610483339"
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
