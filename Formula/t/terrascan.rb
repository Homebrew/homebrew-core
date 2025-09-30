class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://runterrascan.io/"
  url "https://github.com/tenable/terrascan/archive/refs/tags/v1.19.9.tar.gz"
  sha256 "13c120a63d7024ca8c54422e047424e318622625336ed77b2c1a36ef5fb1441c"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b40d6c29fb9eecb6f19626e2f1b9f65babf3be3388542f81ed459f153a49399"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55eba53ea3122827a508c8e157c2454488eba175c7be3f8bf5b936de423b0139"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f60423de629cd20ce0ff69e89135366135b39210338c3888c2431b4c7426b9d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "592b8157f3ccc5c93b0639f8309a4a5a302ca89df28ac7d2d0952844db61966a"
    sha256 cellar: :any_skip_relocation, sonoma:        "32e3939c3b64a6998af3fdb27aa6d47e783c4add9025b96b26a752075c5759c8"
    sha256 cellar: :any_skip_relocation, ventura:       "d8339a426f1cdf82ac986fdf3a72ecb4b8405c2c34f17552aca0ff55218de9ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b993936733949479fd684722cec212f9820553e9e21fede7b3da620067c1a69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc9651bca3ae4b21cea476f602ee391066e161aa1151a3eb80d32b5c725ffe1e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X google.golang.org/protobuf/reflect/protoregistry.conflictPolicy=ignore"
    system "go", "build", *std_go_args(ldflags:), "./cmd/terrascan"

    generate_completions_from_executable(bin/"terrascan", "completion")
  end

  test do
    (testpath/"ami.tf").write <<~HCL
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
    HCL

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
