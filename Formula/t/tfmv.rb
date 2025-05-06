class Tfmv < Formula
  desc "CLI to rename Terraform resources and generate moved blocks"
  homepage "https://github.com/suzuki-shunsuke/tfmv"
  url "https://github.com/suzuki-shunsuke/tfmv/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "67bb684c723d2abdfd0ecfbce030503e05940103305ee131c6b4da64f86c84b9"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfmv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17ed9dfd157233dfd46b51ab27d61dfe27ac116f5a69c1c1c1cfdcf4188b5c79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17ed9dfd157233dfd46b51ab27d61dfe27ac116f5a69c1c1c1cfdcf4188b5c79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17ed9dfd157233dfd46b51ab27d61dfe27ac116f5a69c1c1c1cfdcf4188b5c79"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b9ce03dd144442551b098971829eef99e9baaf5248f4b2c5aa6a9bfa32199ff"
    sha256 cellar: :any_skip_relocation, ventura:       "8b9ce03dd144442551b098971829eef99e9baaf5248f4b2c5aa6a9bfa32199ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37da63bcd510112e2ccfbdf666bb12b1f741ef1de37afda965510bfedac63b7f"
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
