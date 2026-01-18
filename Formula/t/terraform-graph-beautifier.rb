class TerraformGraphBeautifier < Formula
  desc "CLI to beautify `terraform graph` output"
  homepage "https://github.com/pcasteran/terraform-graph-beautifier"
  url "https://github.com/pcasteran/terraform-graph-beautifier/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "36762a21cfdf34b2082b8921d4352c3160d759a7a3743225f1a084f9b3dffe4a"
  license "Apache-2.0"
  head "https://github.com/pcasteran/terraform-graph-beautifier.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d25d1b1141dac30d981d344f63b304c48b778155f6a457b000b965eed8a219d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e0baf8c158de8191e5c9cbbd0c77397e78d000045857e37784c3dd73cc9e042b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcc2b1e8bb7321d175baf7210354cd1985c2caf162445b0ad0bb89edf0f9277a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca9777ce209ebb0f9e47c71c583c89b15f0d07fcd35e5e074dc706674b37e5ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23548a3575b9f6295ba84f0bf527aa30449cb20cc57096d5b781d7e1e7defbdb"
    sha256 cellar: :any_skip_relocation, sonoma:         "967666b68ef9c9fe345f6d8386a43394f334f42a7b99dc6210b1daf40ddfbbbf"
    sha256 cellar: :any_skip_relocation, ventura:        "168a8f71bd4555a7ccb1adae9040df668957d296ea1c48d08229833445fcf2f8"
    sha256 cellar: :any_skip_relocation, monterey:       "ab5d8a20c580aa7d871511a0f2594d980931eec5c2be920bf25f0c2a452900f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fc3a3550aa27a8ef0d719a9e9e256fdf9995034b3e67de8ece8c1f0812d3bc5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfe06d0bcfb50ee315da696362d5a635846067f2601f2669b6b1274b8d8cff48"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
    pkgshare.install "test"
  end

  test do
    test_file = (pkgshare/"test/config1_expected.gv").read
    output = pipe_output("#{bin}/terraform-graph-beautifier --graph-name=test --output-type=graphviz", test_file)
    assert_equal test_file, output

    assert_match version.to_s, shell_output("#{bin}/terraform-graph-beautifier -v")
  end
end
