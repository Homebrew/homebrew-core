class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.15.tar.gz"
  sha256 "de5066d39c30deea6a32f237ce215a4cd9388ff69343649ad6a940db06debfb3"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1eaf047ce8150f1feecb975470b97bd971d32720adbc01885fa5d469592efa9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eaf047ce8150f1feecb975470b97bd971d32720adbc01885fa5d469592efa9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eaf047ce8150f1feecb975470b97bd971d32720adbc01885fa5d469592efa9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "660ca0d854f4f6e4fae7ba34868905d20c1bea133bba07abf943592e15e3ebc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d71bea60799faab717d6ed7eb2b9c243e62411ebfaa3451454d03057dc57a69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd2d37d70285a270280950b30822c5472e7021d62fbf7ce2666e0e6ac76e8beb"
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
