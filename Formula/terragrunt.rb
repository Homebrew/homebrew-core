class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.8.tar.gz"
  sha256 "101daa44aba15c7426d74353f973c0bfc2699965766795c975861fc460b48343"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "16d4538c5040ad09dee44322b197f8bdacde1033ea755ac24ebde420f66dc368"
    sha256 cellar: :any_skip_relocation, big_sur:       "148b28e641e7764cbde59b8a8fd280a577826408f87c0cd8730efd49c5695793"
    sha256 cellar: :any_skip_relocation, catalina:      "3d3e94d1849b25e056b4d509137b7b1ceacb048005607e1316aabb1f8c5e9a55"
    sha256 cellar: :any_skip_relocation, mojave:        "372f50a8985ab33529a03e9d942735be7c50fac8b0a3957b184c473478820a8a"
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
