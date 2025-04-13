class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.4.tar.gz"
  sha256 "b3bc71ab55f7f42a830fab242143256c7f7cc229a28dfb37f5cabcc4f4629ce6"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91bf37acdcbbdc231102894bba2468935b02800e0b97b75013b2bc69b23e6412"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91bf37acdcbbdc231102894bba2468935b02800e0b97b75013b2bc69b23e6412"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91bf37acdcbbdc231102894bba2468935b02800e0b97b75013b2bc69b23e6412"
    sha256 cellar: :any_skip_relocation, sonoma:        "3080ba5d4be4d2a50d62c2ec4ba05050e44717f95e79781f41d9de94f0b7d541"
    sha256 cellar: :any_skip_relocation, ventura:       "3080ba5d4be4d2a50d62c2ec4ba05050e44717f95e79781f41d9de94f0b7d541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13a6f9bb1b34d0f07b8682dffb8f5a794421a12470702721d4b69c6358deedc6"
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
