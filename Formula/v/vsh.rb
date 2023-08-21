class Vsh < Formula
  desc "HashiCorp Vault interactive shell"
  homepage "https://github.com/fishi0x01/vsh"
  url "https://github.com/fishi0x01/vsh/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "713d8f8901c7fc3b2c9c620ce928fa17e3b5a5f949d0dd37ad5ad48ae46dab4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "871ee8e3e5c1932489003c5957639f3a79686355b4f59804ecd5cd81d21411a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53ffd41f78569a0a90d14c10042b872aed3ec9157712ca0c7f9d23cc693bad2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04d0cc010e2f5e7e53ced4cfb0bf9154affb30d24f4d81fe0d3ddf360f03671f"
    sha256 cellar: :any_skip_relocation, ventura:        "315c73a67edf5b6dc7c55b3b9bf3553760b0d665b9292479dc839125e864d7f6"
    sha256 cellar: :any_skip_relocation, monterey:       "f6ce8998843e3c16788807ab0c5a9a88ce077ddc9999db307f14cb2ba6e41184"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c01ddb42c6236f01d1e79f5392a3638926a19769cf230a54e2bcb4f35c8383c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffc2745dc23d2ca0e8086d800c808a407819ef59038bc3d86981c15e5235e481"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.vshVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    version_output = shell_output("#{bin}/vsh --version")
    assert_match version.to_s, version_output
    error_output = shell_output("#{bin}/vsh -c ls 2>&1", 1)
    assert_match "Error initializing vault client | Is VAULT_ADDR properly set?", error_output
  end
end
