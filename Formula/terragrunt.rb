class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.28.5.tar.gz"
  sha256 "8b8dfd95e997878533116b71716eb749434f10fa3ade549f887c451d59fb804c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "78d770145f74c1dcf18b5f6d5665c6ca96c8251df38b2997de6cdec2d51d3e6b"
    sha256 cellar: :any_skip_relocation, catalina: "17b5acf67a848b334e6c2f9e0e087821dbf6e976ba5d17d75119e3354af11fc8"
    sha256 cellar: :any_skip_relocation, mojave:   "fd4ad2454cad5e3251af125cf275ce351f733b65422390377af824a63aaab82f"
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
