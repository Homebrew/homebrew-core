class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.44.0.tar.gz"
  sha256 "fa7818c60495809180c3568107c43c1d2188457e2d2887266a7240861b6f4dba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "baa0be33c683fba7e4d4fb9dde640b8cba222bc4fca875da636b2098128ca49c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b3f97b5de4448295483b3fb357c38a84678c5ec2c5308d80a5148301eb75455"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68cc53e85e2fa91f0dd9e1003d9d7ed48e95870e5275a2f32cc21c61258b8f09"
    sha256 cellar: :any_skip_relocation, ventura:        "6b103f75e0d49357131ac9c41f40629210fceeefacb414de59c9e6b8eac77cf2"
    sha256 cellar: :any_skip_relocation, monterey:       "d04e66d80c914148cfce1fd925d8f41d9bba53dfb819d6cf248137ba7cb684e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "774aeab9cf52fcc8e0995aa66482ebbbd9ff992c19a9042a2c8e4cc0a50e0b64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef4019fd0bb16bd4a6a90f14970283dd3f7a98c2d9e3931c25f63def1c5513cb"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
