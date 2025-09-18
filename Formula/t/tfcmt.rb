class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.11.tar.gz"
  sha256 "a9dce414fbffd42be2bcff52e403c2296260de5fe6a3828c76f33014f21d82c4"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b97f0aca9cb00393ec7c7082768290dceccbc142f409339cecbe9f1e712e3f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b97f0aca9cb00393ec7c7082768290dceccbc142f409339cecbe9f1e712e3f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b97f0aca9cb00393ec7c7082768290dceccbc142f409339cecbe9f1e712e3f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b97f0aca9cb00393ec7c7082768290dceccbc142f409339cecbe9f1e712e3f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe03ddc9d6a3352836e7b53373abfc2c7aa734f192ccb573763e7afe3caa0ca8"
    sha256 cellar: :any_skip_relocation, ventura:       "fe03ddc9d6a3352836e7b53373abfc2c7aa734f192ccb573763e7afe3caa0ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cc2856ade72bdae00eaf63849ba5224d998531052c2df94a1c49ac222ba2a76"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tfcmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfcmt version")

    (testpath/"main.tf").write <<~HCL
      resource "aws_instance" "example" {
        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro"
      }
    HCL

    ENV["TFCMT_GITHUB_TOKEN"] = "test_token"
    ENV["TFCMT_REPO_OWNER"] = "test_owner"
    ENV["TFCMT_REPO_NAME"] = "test_repo"
    ENV["TFCMT_SHA"] = "test_sha"
    ENV["TFCMT_PR_NUMBER"] = "1"
    ENV["TFCMT_CONFIG"] = "test_config"

    output = shell_output("#{bin}/tfcmt plan 2>&1", 1)
    assert_match "config for tfcmt is not found at all", output
  end
end
