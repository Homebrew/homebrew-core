class TerraformProviderLibvirt < Formula
  desc "Terraform provisioning with Linux KVM using libvirt"
  homepage "https://github.com/dmacvicar/terraform-provider-libvirt"
  url "https://github.com/dmacvicar/terraform-provider-libvirt/archive/v0.6.11.tar.gz"
  sha256 "1b13a64d52ee672178b278cd705ebb4529e06e3692ed5dbddd1a09f2ef8e5e4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d368171de77d235069741c96abf783953366f65bd828ef5107a753febc1d620"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ab4ad2414c19304136f40737e4106480fa4a9263529b88631033c1a1029943f"
    sha256 cellar: :any_skip_relocation, monterey:       "c7cff5db890d05e819e26e41909e1a16d00afc1c4fc8414e1f7e7b5a9beaf2d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3edd031a2893cad825db3a00140cb6ffb949cd20e1d8c7d7f4de64aafbcd6be"
    sha256 cellar: :any_skip_relocation, catalina:       "c2783859d88adbd62994dc3a1c81d19ac363429636fff8f6e84658c6ccdab115"
    sha256 cellar: :any_skip_relocation, mojave:         "a9a2db100d57c0485bb9b807d819c5b942bba212d88b10845cdda1f18bf54e2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb290f4b615487538a06594679e884eb06789c707c6ca5fe9626927b4e2392b4"
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
