class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/v0.6.11.tar.gz"
  sha256 "1b13a64d52ee672178b278cd705ebb4529e06e3692ed5dbddd1a09f2ef8e5e4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5af03bb6fc783245cc5c381064f4c9e33f1bc2eb3247d744bb0fcbf299b40d1b"
    sha256 cellar: :any_skip_relocation, big_sur:       "cc56b0c112c68d2162e29b5f006c5959126c1a11dd902c94f0e93ef569f4c7cc"
    sha256 cellar: :any_skip_relocation, catalina:      "ed2ab9fd1374c7c7da79b9820fa3b683fde5a8ddf5afede461548db87e6ead42"
    sha256 cellar: :any_skip_relocation, mojave:        "866e9b5525164e04e5c3a68983e02b742a80281d00dba7255c05e813518343bb"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  depends_on "libvirt"
  depends_on "terraform"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match(/This binary is a plugin/, shell_output("#{bin}/terraform-provider-libvirt 2>&1", 1))
  end
end
