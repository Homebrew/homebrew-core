class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.7.tar.gz"
  sha256 "a4c7407bded6d9d745872fa0813c6dee832bd28d6697a13416d5cf8cc6db4254"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd38759529061faca9c17bd9bd4f698709ebc102fb494648490730e240f3be27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd38759529061faca9c17bd9bd4f698709ebc102fb494648490730e240f3be27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd38759529061faca9c17bd9bd4f698709ebc102fb494648490730e240f3be27"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e030f07a67285696d0edd657d313d1aaf6227a58855903cdab41f341a35cb45"
    sha256 cellar: :any_skip_relocation, ventura:       "7e030f07a67285696d0edd657d313d1aaf6227a58855903cdab41f341a35cb45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52b2bc80de16b004369e2ab6000fee4e10ff873ea41f6234b2ba8d84e03fbf81"
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
