class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.21.tar.gz"
  sha256 "38302ccc161530ec206f0b257ad009d9a1ce61e83a47fe9981758c300c3d7a38"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    manifest_sha256 "cfbda4899f6e87735f4eac9caae34e6fa1c847e768a10e5492beb03d3173df11"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "01e869393dd0b59506f244d40a56c9ad12da955f48939d0cc8f45b3e8307eb8a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "01e869393dd0b59506f244d40a56c9ad12da955f48939d0cc8f45b3e8307eb8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "01e869393dd0b59506f244d40a56c9ad12da955f48939d0cc8f45b3e8307eb8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bb029b08284603745f731b17eb117cbbf041117a3a34da1dcee4ff961db4d0eb"
    sha256 cellar: :any,                 x86_64_linux:      "081d8b51274173e241c8402efe1716c5d9512b928101ad6e168422852f68eddb"
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
