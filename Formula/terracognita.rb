class Terracognita < Formula
  desc "Reads from existing Cloud Providers and generates Terraform code"
  homepage "https://github.com/cycloidio/terracognita"
  url "https://github.com/cycloidio/terracognita/archive/v0.6.4.tar.gz"
  sha256 "b9282055bf2235e0f8b9fbc1ae31c22909986ee3b3df5cc64e644b34f6513485"
  license "MIT"
  head "https://github.com/cycloidio/terracognita.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8bcd4362188f72c3de80afefa3d8eb07ce32cc31270afebc6d0e379a6e8c750f"
    sha256 cellar: :any_skip_relocation, big_sur:       "e0fa9596e95a1fd5b7fad0eec6efc77279e34359fd5c13851945f5e8cf789258"
    sha256 cellar: :any_skip_relocation, catalina:      "b8578fa3b4d8e146e82ff3f4c5a033c980ba5e72c63f2558ee530d1fe6c32387"
    sha256 cellar: :any_skip_relocation, mojave:        "da3ad7e032bfba9ef62a22cfbeafd978a98c853ec38ed228498c9605297276b8"
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
