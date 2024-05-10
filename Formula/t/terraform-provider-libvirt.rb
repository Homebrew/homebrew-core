class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "03a8305b3f2361dc8a147ac4ea0897ca3cc66387ef4e7346d2233324135e1b8c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af8e2d2767deb491fe52c589538910f0125108df32b99e2eb2673b9b832583b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "039f6f0584895578e8ce22ae6fa672085b8dc7570f0dd1f839f14a8d9da5fc55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "becb91fd9ed17ff8920637d64ead27d04febbc97c7ee1d1b309df567b5f48a9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c24acaffcfbc242c6595a27f74c8dc1c54c410ea88bdd716b8f75898249a949"
    sha256 cellar: :any_skip_relocation, ventura:        "acb7528f7104969d4c818ed9ebbe90d18af5c5b30c60c00738044fb82ef12aee"
    sha256 cellar: :any_skip_relocation, monterey:       "28158c6856dd0781f594ee360a0e7f00ee31cfdeab226edfa67f912be66c3aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "320271fa4f1e4b39e647eadc0a06434bf8a7d0951197b31e3e6539fc0cee1e64"
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
