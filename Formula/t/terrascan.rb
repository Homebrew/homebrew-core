class Terrascan < Formula
  desc "Detect compliance and security violations across Infrastructure as Code"
  homepage "https://github.com/tenable/terrascan"
  url "https://github.com/tenable/terrascan/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "e3ebce8fb568cd1e95dc0d65efaedd494395f38f24a992c0d7b2992ad5aa4710"
  license "Apache-2.0"
  head "https://github.com/tenable/terrascan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45aad746bc1b33b483be3c97ffef22bc701d45d4297f82a579bc96fcbd1099be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47fcdd7cd90f8699dabbaedc1a2835351f163a69e3ae80b60a292bb389b8fa48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59ac6463ff2328b1cfcff76477f9cd0f50ae2356b3a79d3c9a27cfc3e3ebf9a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5746733f739c98673062f987d42be6456d99a8d4dac351055f38efdf8d8d927"
    sha256 cellar: :any_skip_relocation, ventura:        "6bb1e1c7a849f2b1b114672317549eadb1b38942a575c9fbc12fa5a24eb9ab79"
    sha256 cellar: :any_skip_relocation, monterey:       "b30ea03579d48952f3aa18bedc6211cb077b54b1eea3c7664ea01753a5172a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc5f3b5bdc7ef1bc4e7d1bc31ba5844c95540b0638e0936c5f7956a67ca21b1c"
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
