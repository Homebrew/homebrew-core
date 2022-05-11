class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.37.0.tar.gz"
  sha256 "71b2ea2cef20fdd408f0be3f6ea867934eaca16912d691067801d9e55453751b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfb0bcde14f9f1c312ea1ae105f8e58eee56a7155f299c154005bc3e6131b735"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7dd54e6b13f1371cedb4995279bf76c51701bb65dcd3e169c279e610dfcaa5eb"
    sha256 cellar: :any_skip_relocation, monterey:       "d6e45f2a74ed8b241b2e1beb08e0452c8e5ea7ae56f359e3d7d790326dcfda7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "03d51bab2438b55d5a2059e78cffa2e426c000993263d1c5f41a6d06dc90f116"
    sha256 cellar: :any_skip_relocation, catalina:       "1bdd2053cac95f268d05685ba3f041914bb7104279eb84aa64f821df9828eb0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93fca3d764cda50e4721053784b30c3fc64517ea732103333303da93a78fee5a"
  end

  depends_on "go" => :build
  depends_on "terraform"

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
