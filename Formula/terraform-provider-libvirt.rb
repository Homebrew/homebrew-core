class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/v0.6.14.tar.gz"
  sha256 "0d429663ee29e4bf5138fe31245db378bafe81011adadf2983b307af0e5356a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55998af49e41b4c18ffdec811449ca8a3343c6febdc8973dcfbde62c62d1d15f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ec68a2023515fe2c39d67035067b19513c1e35a3f0497444b14166b049cecdc"
    sha256 cellar: :any_skip_relocation, monterey:       "b66d5d7be58a4c63f813d930fa5ba4636b1b0ba607045b56051fcf661cfc44a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c7abd0ae49e730f3920bdc3e21760cdb01d3f2a9f8adef1c40dce133950816c"
    sha256 cellar: :any_skip_relocation, catalina:       "5d627d26c7d94d2593ae1995b3e9f6826283f04160b9ef991e975d3f6595df0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d825742da0cbe9024942e1ff42e7e2758428ae0c7e78cf6816af563700f2038"
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
