class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.12.tar.gz"
  sha256 "c21afa0421722529433c971dd8954b77db38632b069969798d908e650ed07b5d"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63e4a7dc88d9cbe39de88bbf3ab86801a43867f95dc8b9353b099c1382c579a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63e4a7dc88d9cbe39de88bbf3ab86801a43867f95dc8b9353b099c1382c579a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63e4a7dc88d9cbe39de88bbf3ab86801a43867f95dc8b9353b099c1382c579a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d4a2653cc8b2ce7f03c5d283d41af04cdf9f9546530d3e19d59598c02827552"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a65399c5f4122b404d9dcbcff2007134b150d3b860653791c9bd69bcd6969d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec72c09333e81c102ffb4d5f0eaed361f54a839a38f1caf2418a565f39787683"
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
