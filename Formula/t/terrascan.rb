class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://runterrascan.io/"
  url "https://github.com/tenable/terrascan/archive/refs/tags/v1.19.9.tar.gz"
  sha256 "13c120a63d7024ca8c54422e047424e318622625336ed77b2c1a36ef5fb1441c"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f548e99a8e16458976232da128ae6fcada6d1cc55e8edbf9024b61b1970c0281"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "249806064b0f29aa7cfacb3edb151395fb0bdde93757a57ed2f6615fc040f3f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "beaad3a02bcafa37cbfcee86acf828f8ea7f4f4000242e94bf55a1a5422ecc30"
    sha256 cellar: :any_skip_relocation, sonoma:        "62940c84abe027708c05b34ab0d12ac12cace1ac3018f1b920d2cc7e6f8905d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c12b93bc3bb302df968d5dcf5d29996be31cc9c2c7aa5cb2b7e33c0ce116c7d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f4afb9344d871a99682efd65c685f87664a72141ff6464da158c1bed04a5ac9"
  end

  deprecate! date: "2026-05-23", because: :repo_archived

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X google.golang.org/protobuf/reflect/protoregistry.conflictPolicy=ignore"
    system "go", "build", *std_go_args(ldflags:), "./cmd/terrascan"

    generate_completions_from_executable(bin/"terrascan", shell_parameter_format: :cobra)
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
