class Terracognita < Formula
  desc "Reads from existing Cloud Providers and generates Terraform code"
  homepage "https://github.com/cycloidio/terracognita"
  url "https://github.com/cycloidio/terracognita/archive/v0.8.1.tar.gz"
  sha256 "dff35a6913d64dbd4e0595bd15d2f2029a8605a8bf0ba32a1de95f3236d85f1c"
  license "MIT"
  head "https://github.com/cycloidio/terracognita.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63f50353e0b1426383b3eee07a87eed571b617cc93589ac1e4254d67f8227834"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b53dd1ceec5ddfff075c398cd24ca74f21b4138db629bc7f65978862369bcd34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7ecd47c9c3e4021264cdf69f8e70dc94a149eb4076d7cf8e97f78fefa5ca3cc"
    sha256 cellar: :any_skip_relocation, ventura:        "1332d22ba3a83dae175a04b49131bc171a0153eb3d482cc063913f406921612d"
    sha256 cellar: :any_skip_relocation, monterey:       "8345abff73f0893b1ac9328f0cfdf4bbb926b79bd2101fe0b5566d3032dc49cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "7460a4ddf60cec0fe51e86b98dc39abab4ba5b50ad6a5c4c987fc9dd3765a014"
    sha256 cellar: :any_skip_relocation, catalina:       "b86f9559051ced717bef608d9997f073d1b4af491fdafa736e679b7bbc6c0fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cca175e1cbaf3603eb6a2fcc5fe52369a0b644a586028aaae3505950fe6569e1"
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
