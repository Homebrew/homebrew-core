class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/v0.7.1.tar.gz"
  sha256 "a540d3f5fc6afc7ee7759d03a43f85df7af2263fdfa6d73a8014fb4f5c480fa5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "335b225a4a6dd7fd48fc292ae3829ad26f01365f271a9b4c7d965bdc1c1233fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a99d4558f10f6d9a24860ba42908e0fd6e5704c6218477d1ccb20268c25d199"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0fe876c72f0393c1afa0419c0153b1cc42fb8d76340413b447e6feb12c2c82c"
    sha256 cellar: :any_skip_relocation, ventura:        "90e16f849bb32ed97d4558e7748fdf825602211f2abf25248f34521460f4e258"
    sha256 cellar: :any_skip_relocation, monterey:       "53ee35a68dee46b5d4130c8bd40fd7aa980f6567935f837c31e5fc2ee3e7ed87"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f342b2c06761eb27b0fde6a3a81a7a26563e72020df3296547fe04dd48dc0c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5d4e59ee77616ee37b6821d033bfef567d930e06162cec6c1525a72a87a3f2c"
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
