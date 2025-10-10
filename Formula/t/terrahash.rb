class Terrahash < Formula
  desc "Create and store a hash of the Terraform modules used by your configuration"
  homepage "https://github.com/ned1313/terrahash"
  url "https://github.com/ned1313/terrahash/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "3f6d3db33167a77290741ca24ac32cb82f18400969cde4e501c84d250801758f"
  license "MIT"
  head "https://github.com/ned1313/terrahash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c4b9014227d119a55bc9f42a5b244a12b88f0b19f09fdd85e3514b42d61682eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3bff28cc077e366d5dcef34c43192ea54defa55bce901fc53eaacfe329c194d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2827a0447062c2ee47306aafa09964dcbf25713e403461e3cfb3ed62ec9b11ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5309604e6a55ef456ba83b7bbe1c2ff8a24bd18b54703979737bf9500de7433"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92e077e939732efc7b7809f338e561103207273c1c54d3fbc29b5315dd11c920"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d73a995a7cd3b4ab3beec53269ad53cffffc28e76fb7f9a88b4e065ec1771bd"
    sha256 cellar: :any_skip_relocation, ventura:        "4645c23fc4859d34d2d03e6e1ad252dd833cb00f3d16be8996468e8f1507184d"
    sha256 cellar: :any_skip_relocation, monterey:       "a41c2cebf76de380cabfa016a7403e93b46367daa53570645543153013af6648"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2d25b8e45a3885003a2ded44bcf917175d7a383659472c7d520e487cbcf8d1b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c60a0bdc8f9cb977a7e4b7804e1d845f70af7e697b06c2e1eca856ac55f533f"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"terrahash", "completion")
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
