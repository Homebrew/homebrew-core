class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.17.tar.gz"
  sha256 "990119d00e30377e2a909529f55841443f1ebb49ef725b98c5c0dc28149edf84"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "020975c214d30e103084e599c0768d7ade244e8a621810e2101d57bb692240bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "020975c214d30e103084e599c0768d7ade244e8a621810e2101d57bb692240bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "020975c214d30e103084e599c0768d7ade244e8a621810e2101d57bb692240bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad72d6de98f616896dac92baae0addadcaccb360e4feede25366fc6e8ba236b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40617379eebdbf358d806ea5fd212220afa6bf74448e9e1cf66335056d85c72f"
    sha256 cellar: :any,                 x86_64_linux:  "c44d83871fe710e8240e0bd4876f48a9f47c14f52162b422c5e1f6159018d22a"
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
