class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.18.tar.gz"
  sha256 "5a256fedf22b5f6e6314b6cb5c658e0a75b2853a85d0d3c8469f78a02eaa2026"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40350aade26274af1d684d45eac58a48a82da8f29d4185d6708e6391ae97c1cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40350aade26274af1d684d45eac58a48a82da8f29d4185d6708e6391ae97c1cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40350aade26274af1d684d45eac58a48a82da8f29d4185d6708e6391ae97c1cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6abc38ea225826364521be3c6b6ebe63f569e7627064a145e1408f7a05511a15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65fa2c2282b4ddf7f1cafe208a11b3f76e8c4437667c65d03a985972dde343e0"
    sha256 cellar: :any,                 x86_64_linux:  "288242994c794bc0d8731d253627d39a34755e1c86928640c13dc2aa78db9a55"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
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
