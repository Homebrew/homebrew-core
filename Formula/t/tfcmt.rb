class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.5.tar.gz"
  sha256 "a32de1e3ae222caa080520d88b10390bf29dbbf0faeec0a9d9bec987a3802a4d"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98c4296e84631af6c5206d0e75abdccbb05d3485e525b6ba34a4f2e8fb515845"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98c4296e84631af6c5206d0e75abdccbb05d3485e525b6ba34a4f2e8fb515845"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98c4296e84631af6c5206d0e75abdccbb05d3485e525b6ba34a4f2e8fb515845"
    sha256 cellar: :any_skip_relocation, sonoma:        "d88ec52245fcc41015da09725f8721b889d244d02c62a3ac29aa5ef6c63983f0"
    sha256 cellar: :any_skip_relocation, ventura:       "d88ec52245fcc41015da09725f8721b889d244d02c62a3ac29aa5ef6c63983f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6af6d0838f7f8c77aa3ab7ca42e9743e6d22eb045ccb0f322f63e9c22f5bb128"
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
