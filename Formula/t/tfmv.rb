class Tfmv < Formula
  desc "CLI to rename Terraform resources and generate moved blocks"
  homepage "https://github.com/suzuki-shunsuke/tfmv"
  url "https://github.com/suzuki-shunsuke/tfmv/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "c2ae0d1c0bb5d0d7cdbb256f8a784753df5c2f9e1175e91449849efe5a7e668f"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfmv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "068e9b03ab71694280924d8badc57117372b569947727d31be1752343f40d524"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04674f9a20ae847e01db7ff8f04cbf24daa3b41bed2ce646830804c2843493f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04674f9a20ae847e01db7ff8f04cbf24daa3b41bed2ce646830804c2843493f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04674f9a20ae847e01db7ff8f04cbf24daa3b41bed2ce646830804c2843493f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cc0e643c4f038d1a84e0366ebeceb14d52dcdc7c68941a2da84257098bcfc4c"
    sha256 cellar: :any_skip_relocation, ventura:       "9cc0e643c4f038d1a84e0366ebeceb14d52dcdc7c68941a2da84257098bcfc4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60fdec9de2f834f8cf0eabd9dfc59cbe2258863efa75bd42928dd9fb17bd9a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43eff6cba1a9ceb6e4896c71b7924740f0354ad148eb2379208e6d0a3418fb95"
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
