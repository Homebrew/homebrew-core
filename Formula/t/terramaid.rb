class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "6b6e797d2ce5038414307af19cc0aebb2363cbfff66828610f814f61b79e377d"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d9286e0b8856b587c83a56f03b6b3dc08613eae3fec76299525360091eefe69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d9286e0b8856b587c83a56f03b6b3dc08613eae3fec76299525360091eefe69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d9286e0b8856b587c83a56f03b6b3dc08613eae3fec76299525360091eefe69"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a7e6f9cc76b33e119276a960ceb16bf6ca1ace2907bb147c8f1fd41b2c70f2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d89d47b37e93c8f5bdddfa1247f11c8447b6f55f016b6b7960c96a19eba857b"
  end

  depends_on "go" => [:build, :test]
  depends_on "opentofu" => :test

  def install
    ldflags = "-s -w -X github.com/RoseSecurity/terramaid/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"terramaid", "completion")
  end

  test do
    ENV["TERRAMAID_TF_BINARY"] = "tofu"

    (testpath/"main.tf").write <<~HCL
      resource "aws_instance" "example" {
        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro"
      }
    HCL

    system bin/"terramaid", "run", "-w", testpath.to_s, "-o", testpath/"output.mmd"
    assert_path_exists testpath/"output.mmd"

    assert_match version.to_s, shell_output("#{bin}/terramaid version")
  end
end
