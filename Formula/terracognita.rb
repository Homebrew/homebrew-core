class Terracognita < Formula
  desc "Reads from existing Cloud Providers and generates Terraform code"
  homepage "https://github.com/cycloidio/terracognita"
  url "https://github.com/cycloidio/terracognita/archive/v0.6.2.tar.gz"
  sha256 "7e3f7e8e6ce231fbc0a9c4f88ee50e7e4fd287287fa79d9464c9555ebc883916"
  license "MIT"
  head "https://github.com/cycloidio/terracognita.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "53bf006ea48142eaf015dc5b1a2ab975d14ffc7b185e43df110425d3d580e7d6"
    sha256 cellar: :any_skip_relocation, big_sur:       "5ba9130b7d087ec215f1923f94a8f996e9fb3f0f15ddeea7bd0c5671f5f1fd75"
    sha256 cellar: :any_skip_relocation, catalina:      "742b962704c5aaec5a00f8c199245b1e65e86897a2cae3fc198def5d2e8714d8"
    sha256 cellar: :any_skip_relocation, mojave:        "73ffb4cbe1327d3286a07330a0db083f45f00244ebf4c520e1c108cc283cfd30"
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
