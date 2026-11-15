class Tfmv < Formula
  desc "CLI to rename Terraform resources and generate moved blocks"
  homepage "https://github.com/suzuki-shunsuke/tfmv"
  url "https://github.com/suzuki-shunsuke/tfmv/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "dd9bfc90354333876e46807e5f4a17105e799e59a8493171c61e32be7d816490"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfmv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a6b8eda21963e159deb2ca52e2d393eaedfcecd91cc42c2eb1e49c2e116c13d7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a6b8eda21963e159deb2ca52e2d393eaedfcecd91cc42c2eb1e49c2e116c13d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a6b8eda21963e159deb2ca52e2d393eaedfcecd91cc42c2eb1e49c2e116c13d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0afc7eeb09b97a8d3394d20bac5e76ced9026b854ef1d808f816c62f6e475935"
    sha256 cellar: :any,                 x86_64_linux:      "4625bc4345a4a1460df4adf46aaf7b911af7103980aa4c52f6367403ba5e299e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
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
