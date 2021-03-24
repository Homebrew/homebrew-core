class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.16.tar.gz"
  sha256 "8886a77cc4a6599c1c8bf900900b95b30586c178a1459e177d0e08292886fc3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4fd3286477af74a390263c04beb4816c5ba410518c6ebaeea031027eeb1f4a86"
    sha256 cellar: :any_skip_relocation, big_sur:       "f214f0a90e5fa8118fc2670900af372aeeb7cdced69f7ef7baee552f4370b719"
    sha256 cellar: :any_skip_relocation, catalina:      "0c88086fa9624f142b256ecf01c22b0f61dc1df1df35c266a8a81b94055f4507"
    sha256 cellar: :any_skip_relocation, mojave:        "0088d05d7a568bf32257657e104d0f49c788cbe9e1609c10de3d9326ea03b32b"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
