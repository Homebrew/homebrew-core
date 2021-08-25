class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/accurics/terrascan"
  url "https://github.com/accurics/terrascan/archive/v1.10.0.tar.gz"
  sha256 "4fcfc99e64b081f7a202eb9b6edd4e31e9b477bbcc2c21b70090f94c636d0460"
  license "Apache-2.0"
  head "https://github.com/accurics/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "566ae3a7be2f51b3e51d6756c84e5809e14af6c4b883eb9eb14b6e3e1784521c"
    sha256 cellar: :any_skip_relocation, big_sur:       "a4f13faec599cfe1586d6ea8512052e98f72783578f09ff182e6d4d7f01088a3"
    sha256 cellar: :any_skip_relocation, catalina:      "8a064db94da0f9eb0a3ec7e76983a8efae5f450e2537dbfc391688f9da487174"
    sha256 cellar: :any_skip_relocation, mojave:        "eb86095118573dd1bf4435bb54eab1515ab3feb5699fbc8acf3875ecf8064671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "565bf4e1b475f82f0b3e1dd2485bc787cbe651580b63a039a5e733391a42d6c5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terrascan"
  end

  test do
    (testpath/"ami.tf").write <<~EOS
      resource "aws_ami" "example" {
        name                = "terraform-example"
        virtualization_type = "hvm"
        root_device_name    = "/dev/xvda"

        ebs_block_device {
          device_name = "/dev/xvda"
          snapshot_id = "snap-xxxxxxxx"
          volume_size = 8
        }
      }
    EOS

    expected = <<~EOS
      \tViolated Policies   :\t0
      \tLow                 :\t0
      \tMedium              :\t0
      \tHigh                :\t0
    EOS

    output = shell_output("#{bin}/terrascan scan -f #{testpath}/ami.tf -t aws")
    assert_match expected, output
    assert_match(/Policies Validated\s+:\s+\d+/, output)
  end
end
