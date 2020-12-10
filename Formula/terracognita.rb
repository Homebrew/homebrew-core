class Terracognita < Formula
  desc "Reads from existing Cloud Providers and generates Terraform code"
  homepage "https://github.com/cycloidio/terracognita"
  url "https://github.com/cycloidio/terracognita/archive/v0.5.1.tar.gz"
  sha256 "2385d976ace57ca3eac76321be1dc2be70763817586d7d19540a98765018fd07"
  license "MIT"
  head "https://github.com/cycloidio/terracognita.git"

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
