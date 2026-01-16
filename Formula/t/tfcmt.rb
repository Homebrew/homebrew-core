class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.14.tar.gz"
  sha256 "790c67d90ab04a76fa53adeafec9288b20840d4734f86e179d0a2b061fbcbe62"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c973d598c536a59c53b897143d10c55a6d75e1c3d490ab11a17a5cd20b43364"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c973d598c536a59c53b897143d10c55a6d75e1c3d490ab11a17a5cd20b43364"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c973d598c536a59c53b897143d10c55a6d75e1c3d490ab11a17a5cd20b43364"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c13a9379a71841bdc14cda9a78a6a60a7eafd4e87562b034df1e8c2e88aad57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f948b373006f672279aeed3a0f33ddd9e06ecfd053ebd73dc75583688b3b584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6afc48c56e0698c6645c9fc804086d6046189b2ead569195346e70734ac75fbd"
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
