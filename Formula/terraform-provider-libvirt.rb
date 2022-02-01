class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/v0.6.14.tar.gz"
  sha256 "0d429663ee29e4bf5138fe31245db378bafe81011adadf2983b307af0e5356a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e3544c6e2b01ae4ae2701b79a4febe5bfc8efc906b41b944c5c4b50bbc9845a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2a12d1832b8b587dfa8eedbc477fb9aa8985b1042cf3934fb5945eb3879b1f2"
    sha256 cellar: :any_skip_relocation, monterey:       "f0a83a8f45b5d14ebff23e88f930f712f9a44c5b81b8c4c3eac2d909822ca271"
    sha256 cellar: :any_skip_relocation, big_sur:        "487863c0e28c5f2b14a7f783404672d9683c36036d607ea158e91c597ff50793"
    sha256 cellar: :any_skip_relocation, catalina:       "947fd2048624d454dcacc2c3a83ebf28506267a41d0691c59085debcdec98b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92af3b010b23a0f7c643acf79ce19011f8cca26e7494ac8c0365af07adf828f3"
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
