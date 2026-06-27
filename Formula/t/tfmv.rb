class Tfmv < Formula
  desc "CLI to rename Terraform resources and generate moved blocks"
  homepage "https://github.com/suzuki-shunsuke/tfmv"
  url "https://github.com/suzuki-shunsuke/tfmv/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "2783acb97c2b24f311a971cb22ff478ecc2323e2bab402457ef070051f754e9d"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfmv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f8c31d6cd0910bdb3dfef1cd3cd24eefbd5ef4c87beb1cee502c6474e6a74c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f8c31d6cd0910bdb3dfef1cd3cd24eefbd5ef4c87beb1cee502c6474e6a74c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f8c31d6cd0910bdb3dfef1cd3cd24eefbd5ef4c87beb1cee502c6474e6a74c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfc830c36d5a0d948315027d6aafc7ef63046cac5c05bf3d5f8bde730d8bf22d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "161f5173d9a7b3ee6942da6d157ad9570054e9b0af6b3e4c137536ea801582e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53413e3284046bc4560ccf3405f5e187f744083e5264d2f4c9c75cf064190be8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tfmv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfmv --version")

    (testpath/"main.tf").write <<~HCL
      resource "aws_instance" "example" {
        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro"
      }
    HCL

    output = shell_output("#{bin}/tfmv --replace example/new_example main.tf")
    assert_match "aws_instance.new_example", JSON.parse(output)["changes"][0]["new_address"]

    assert_match "resource \"aws_instance\" \"new_example\" {", (testpath/"main.tf").read
  end
end
