class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.29.10.tar.gz"
  sha256 "c5442598879218d0f5a42f2582a06005e5e0d971fe7c1ecedd46440b8d09c63a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5a2123a87208cc879f44ad7e8e9a9dceae727bb51adf61b79f8e51f883b90a08"
    sha256 cellar: :any_skip_relocation, big_sur:       "7658802c826084e1315a44bb2ef288f4b4670be94587213850bbcf0a445e33d9"
    sha256 cellar: :any_skip_relocation, catalina:      "dd8f64d13695c0f6db90bac606e1c378c72738950b3dc887d4ed792ef9acdf8c"
    sha256 cellar: :any_skip_relocation, mojave:        "96211364a399988a27d277ce57be847c248515de686a4a98e4eaef6aea9ae693"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
