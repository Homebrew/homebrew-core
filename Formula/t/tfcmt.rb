class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.20.tar.gz"
  sha256 "c9937126f6d9605f4f3b4fd1233f55d33e2e6b17373e2a41e8361111d257dccd"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "47bb106d3186e10a1b42241a6c66db2edc577e5a157f331e1a2351f3a9e20eb2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "47bb106d3186e10a1b42241a6c66db2edc577e5a157f331e1a2351f3a9e20eb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "47bb106d3186e10a1b42241a6c66db2edc577e5a157f331e1a2351f3a9e20eb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5a3b6b1b944238312f7cecaf0c1686e810bb063c7b9451ba5105edce4e3cd497"
    sha256 cellar: :any,                 x86_64_linux:      "d31068f487ddd4afe0c6bc56ab6525678b65e891648a0daa473910dad9a8dd91"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
