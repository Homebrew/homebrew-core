class Terracognita < Formula
  desc "Reads from existing Cloud Providers and generates Terraform code"
  homepage "https://github.com/cycloidio/terracognita"
  url "https://github.com/cycloidio/terracognita/archive/v0.6.0.tar.gz"
  sha256 "25aa4000fd78ac4005574261026173cb6ba8989e90e80d6f7b14d9efc353508b"
  license "MIT"
  head "https://github.com/cycloidio/terracognita.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "91aedc3bc0275d4519a0bca398cdc42f1c419cc4979b89e9063c04cb58ee9769" => :big_sur
    sha256 "398ddc41ce7c7e92ba66e3e5a7e2d95b0105370db5d6cffb9f825e5d3a5ac393" => :arm64_big_sur
    sha256 "ed1875f71c6e7c16a0857815f3e97e2c258d591b21d7a3fb3db2cd0d4434db5a" => :catalina
    sha256 "f4233f3a50dcd2e872eef49d00b7cbdc80af701dd686039be71d6b2fbb6f2251" => :mojave
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/cycloidio/terracognita/cmd.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/terracognita version")

    assert_match "Error: the flag \"access-key\" is required", shell_output("#{bin}/terracognita aws 2>&1", 1)

    assert_match "aws_instance", shell_output("#{bin}/terracognita aws resources")
  end
end
