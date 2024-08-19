class Vexctl < Formula
  desc "Tool to create, transform and attest VEX metadata"
  homepage "https://openssf.org/projects/openvex/"
  url "https://github.com/openvex/vexctl/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "dc979bb97e370f750946240a84461627b57764299a73332e94350e02f99ef9aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab83abcd96209b3bab971fce6d4e81d22925f9ffa32d90c6c966a82696f26c06"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e48159bef03456bf7ec7d382ef9650cb901f01ae8918f70c84ff41b7f356c3fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d746ed639060dffd7cd6657984fd91f938b3d67d52fe26252f2b13b2e95189d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "9eacd38d53131df0495d4c275dc92c6682dc383b6ef0119a9f0158ade751635b"
    sha256 cellar: :any_skip_relocation, ventura:        "d04a4d2ad93f970075e01645c1cee7c6eb16fe0d7c9e5ca582bad4f1133ae275"
    sha256 cellar: :any_skip_relocation, monterey:       "4b0bac06e37b5f66881cc635c6bf95857227f185d89ada25bbd6b28aa4815e96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f3d5bd002bf2f8415c050fe1cecf07030483c3e31ab2017b3af57fbfd4d8629"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Valid Statuses:\n\tnot_affected\n\taffected\n\tfixed\n\tunder_investigation\n",
    shell_output("#{bin}/vexctl list status")
  end
end
