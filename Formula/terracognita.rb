class Terracognita < Formula
  desc "Reads from existing Cloud Providers and generates Terraform code"
  homepage "https://github.com/cycloidio/terracognita"
  url "https://github.com/cycloidio/terracognita/archive/v0.7.6.tar.gz"
  sha256 "bc2361718cce62fb799f8470a268b9d2af7ab95a8337bbaa05d79f4b636482d1"
  license "MIT"
  head "https://github.com/cycloidio/terracognita.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "779356406af8029270120a4431f8becc18ea033f12feead3a18537155b78b2eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "190d7f3e4c0a501826773434b18ff360390668b971b0a306570e3497951237be"
    sha256 cellar: :any_skip_relocation, monterey:       "5bee638b0b203afa91aefafff36c0660374442426433f843e1beec24dd7a767f"
    sha256 cellar: :any_skip_relocation, big_sur:        "efe1ab20d9ffb256a0185056df055d4aa7ea147942f85715b3f484070f4f4575"
    sha256 cellar: :any_skip_relocation, catalina:       "6012ae24cf3906b66f47fc9861967dd366f91cd1f0cd9221dd4aa97548de88cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eadc6248219a335076c8b317d98a1ad88208b7b5fd9390441c4ca85c238046ce"
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
