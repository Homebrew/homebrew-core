class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/v0.6.13.tar.gz"
  sha256 "cdc121edbe606b5c65279365f323ca99989866a5e4e5d76fdb588482a8fc6234"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f09d7b51b1cb82628ed7cda6630f9ca68dc5579946845cf7b6039e8da54f8b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb0d4ece745a815f896b18fde87a373a8939748a5b9ea4918787448d5e8f544a"
    sha256 cellar: :any_skip_relocation, monterey:       "dfa29e63a1cf32331642c8742d30c1b53a16464581216fcef2c833da20e50781"
    sha256 cellar: :any_skip_relocation, big_sur:        "7503be76ab7aacf2a9f182133e6aa35f28a83891574baf223f05113ffcab76e8"
    sha256 cellar: :any_skip_relocation, catalina:       "0306bcaa93b009451cf64a10d25d1a2b765e3ccfc6ff7291e790f69240c3b07a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cae29cb654a620d134811eb4b1ef78e0d1391f4a7364b44220af804bc2bd9834"
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
