class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://runterrascan.io/"
  url "https://github.com/tenable/terrascan/archive/refs/tags/v1.19.9.tar.gz"
  sha256 "13c120a63d7024ca8c54422e047424e318622625336ed77b2c1a36ef5fb1441c"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b2fb5ff41488184a925a6b87cc13e096305eacab2f3d27ab0f7aac5d0c511b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e885c60f5d7131d1554da25f5a93098ee3a1e9c62e84d0f8de6fa5d2041f31e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1eb67275ff0c8438e897b0b468a5045c4c77c32f9eab47eb54acb554e191d877"
    sha256 cellar: :any_skip_relocation, sonoma:        "c79b75a565ee40b3a0b2cb8a5bad1fca37e81feadbb9b2aec8590877315f1c89"
    sha256 cellar: :any_skip_relocation, ventura:       "b6ada05d7e18a63bfa1f35a22a3b604195f1b00d942da71dd1903abdeab78431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f5129f6cbc94f6ff53a5e88f37b1953c58079eb42ef67046a67d3e6d24cfd51"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X google.golang.org/protobuf/reflect/protoregistry.conflictPolicy=ignore"
    system "go", "build", *std_go_args(ldflags:), "./cmd/terrascan"
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
