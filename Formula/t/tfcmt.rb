class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.19.tar.gz"
  sha256 "5c6fe5d838eb3019cad1f7ba1eb2d2ea4f74617529f0c61ed301036d4dd39fc9"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9f1e15694f309f8e4f765bd2992889f650101b75aa5a491c0448923ea29d5e58"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "90ea369ae934cbb1c8054b6034ad6dd0791cff009eff649e7b898333dc173970"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "90ea369ae934cbb1c8054b6034ad6dd0791cff009eff649e7b898333dc173970"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "90ea369ae934cbb1c8054b6034ad6dd0791cff009eff649e7b898333dc173970"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "84c01adeeab1119b5a356a0bb7a5cadf4999e7286420bd3efe678ce5c4b1a6ba"
    sha256 cellar: :any,                 x86_64_linux:      "4ab375b6b25943e7e0d9b96b9327f5d107efb2838f13bcd31413d2c1bd6cf77c"
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
