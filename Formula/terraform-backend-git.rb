class TerraformBackendGit < Formula
  desc "Terraform HTTP Backend implementation that uses Git repository as storage"
  homepage "https://github.com/plumber-cd/terraform-backend-git"
  url "https://github.com/plumber-cd/terraform-backend-git/archive/v0.0.13.tar.gz"
  sha256 "f1262c52f8b6751c4674c885775ad62f87c7bc13dedd1fa9fb23d9065f483bd0"

  bottle do
    cellar :any_skip_relocation
    # sha256 "a032752d893a2be4c7ade05fed422146c879a5cd4bcf69c8bee4489050ee7244" => :catalina
    # sha256 "44d9ee3cd35d32a1dc33fde30c3e250bd0ac8c92ad6b99451dc2df3c785f59dd" => :mojave
    # sha256 "21588d35f03ccd744d7c4cea52c5e44e34f6a8830d23710bf95965f04280cdf5" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terraform-backend-git version")
  end
end
