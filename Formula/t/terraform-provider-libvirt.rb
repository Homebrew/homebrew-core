class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/v0.7.4.tar.gz"
  sha256 "050437a9681bebe686ebad7ae1a6b0004238302a5775169f47403cc79392741f"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90548fa91fc56460e4cae6098316b93c8974b8fad6f16b75ff6bee73e69a9de3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6d8267f576d037d634ff965a68f6df32711bc925917d6e73bcaca6bb65589e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a2df226c41bc52e85ca841ee43307cfce5bb65c338a65052b8383f0e8bf90d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "53dfeae3c4517a1547ad0ce5b406721798c3175d923c302a30197b4d0670f15f"
    sha256 cellar: :any_skip_relocation, ventura:        "9ec67c174a7791c9dd0687386af384303606e9057f1a01578c06b7a461093890"
    sha256 cellar: :any_skip_relocation, monterey:       "4c23174db4b57b2ab0a3c50b2e77f4b848701c5392e4509b62a0d26f7e9333d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51e0f7463a1a18e5061c3dbd03c5367c720eb6e50698481f99da290881d13ec5"
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
