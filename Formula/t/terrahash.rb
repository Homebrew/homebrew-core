class Terrahash < Formula
  desc "Create and store a hash of the Terraform modules used by your configuration"
  homepage "https://github.com/ned1313/terrahash"
  url "https://github.com/ned1313/terrahash/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "3f6d3db33167a77290741ca24ac32cb82f18400969cde4e501c84d250801758f"
  license "MIT"
  head "https://github.com/ned1313/terrahash.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56190ed3f9318c57e6dad7a1f6677d39b0a5e13990594e4bcf73582b98b450f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56190ed3f9318c57e6dad7a1f6677d39b0a5e13990594e4bcf73582b98b450f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56190ed3f9318c57e6dad7a1f6677d39b0a5e13990594e4bcf73582b98b450f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b6d7d22b28b3616d5278c4cc98d6ca602426c6837e79103667f7692c8cb6aee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31790db6c755801fe40fbeab1859d383e624ef08584612f3e375df48fea56583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a23ea4fdea487b4be85ba254b680311c6e0c2d7520d2857c46c22dfd9ef4eb1"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"terrahash", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"main.tf").write <<~HCL
      module "example" {
        source = "terraform-aws-modules/ec2-instance/aws"
        version = "~> 5"

        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro"
        name          = "example"
      }
    HCL

    system "tofu", "init"
    assert_path_exists testpath/".terraform.lock.hcl"

    output = shell_output("#{bin}/terrahash init -s #{testpath}")
    assert_match "Summary: 1 modules added to mod lock file", output
    assert_path_exists testpath/".terraform.module.lock.hcl"

    assert_match version.to_s, shell_output("#{bin}/terrahash version")
  end
end
