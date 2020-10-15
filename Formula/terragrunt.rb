class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.25.3.tar.gz"
  sha256 "fe0df274084d75899f911934ac253fa4c7ae12a089481f49c14cb9def08984a3"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "59cfcaf22324bc7135306893ed49f053711e435e56a53547f6d38548db10fbc8" => :catalina
    sha256 "894c61a2f2bef53ad17d59d74913e56c73687f00996e5c6e3bc837626d7e16d9" => :mojave
    sha256 "5129346ae9063e50145f6a0767c4141d8a28ea4cd69724b730c885c631d41672" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
