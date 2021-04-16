class Terracognita < Formula
  desc "Reads from existing Cloud Providers and generates Terraform code"
  homepage "https://github.com/cycloidio/terracognita"
  url "https://github.com/cycloidio/terracognita/archive/v0.6.2.tar.gz"
  sha256 "7e3f7e8e6ce231fbc0a9c4f88ee50e7e4fd287287fa79d9464c9555ebc883916"
  license "MIT"
  head "https://github.com/cycloidio/terracognita.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a4e695dd8b2250319a71c3133d7f25409af6f0efc18737defa60e0dc0e3c1f19"
    sha256 cellar: :any_skip_relocation, big_sur:       "248a9f4ff82c9d71b42de68ae5a7992b24b547c917193a13c2cac9dc3a001910"
    sha256 cellar: :any_skip_relocation, catalina:      "d99e0fdb6574512b75d359969466672c67ce5d10cb34e5471a6c33357975c8c2"
    sha256 cellar: :any_skip_relocation, mojave:        "c0f566e26c52a835e0f4eb4c58d9a18a02d67dd4a02552c0a0c0c12e4491e0d3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/cycloidio/terracognita/cmd.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/terracognita version")

    assert_match "Error: one of --module, --hcl  or --tfstate are required",
      shell_output("#{bin}/terracognita aws 2>&1", 1)

    assert_match "aws_instance", shell_output("#{bin}/terracognita aws resources")
  end
end
