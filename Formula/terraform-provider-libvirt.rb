class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/v0.7.0.tar.gz"
  sha256 "d377acb44e5a2383495125494d5590345224313ba35ec116e46593867a560f9c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb615807297c7c263475c9aefc77b7a71b4191bb95578ff1255bdf5a10d957f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3790a8e0e8aad43a45487fdedc2cd5d47b882be05f8ab77e14cb425072322de"
    sha256 cellar: :any_skip_relocation, monterey:       "d36befb071e615c232e155c48a6a3270ae2577b6dcbad08e247a18251aa3b7cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d8799365da3bba56f1161bd425d8b24f83879cb50ba8b4501e6e46282094b63"
    sha256 cellar: :any_skip_relocation, catalina:       "e31788236c8bca8c1947965082c91ab129ed3384061a4d7ee70e4a12f1c9f6aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e7da33b7fd0a2f4b39e47db6da54213b9de1dedbd263adc3a30ddb5adb2634c"
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
