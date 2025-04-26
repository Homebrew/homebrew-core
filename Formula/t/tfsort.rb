class Tfsort < Formula
  desc "CLI to sort Terraform variables and outputs"
  homepage "https://github.com/AlexNabokikh/tfsort"
  url "https://github.com/AlexNabokikh/tfsort/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "0fb2952c52d1f13fbf2a939d5bdd80b6bea3943f94f587ca73b04c6a107ab7c3"
  license "Apache-2.0"
  head "https://github.com/AlexNabokikh/tfsort.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9e96459085e375e9e275166fc1f74db6f2852c8fbfe51ec5111b8d05d7885de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9e96459085e375e9e275166fc1f74db6f2852c8fbfe51ec5111b8d05d7885de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9e96459085e375e9e275166fc1f74db6f2852c8fbfe51ec5111b8d05d7885de"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ab204f1c18c71186e2309b3c6af78d3ab6898e68928948191e0b405ff68c481"
    sha256 cellar: :any_skip_relocation, ventura:       "5ab204f1c18c71186e2309b3c6af78d3ab6898e68928948191e0b405ff68c481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a9db22f4974fdb7edac5af591e89afbe81fa9f14a77d89dc1a59648d8e56814"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    # install testdata
    pkgshare.install "tsort/testdata"
  end

  test do
    cp_r pkgshare/"testdata/.", testpath

    output = shell_output("#{bin}/tfsort invalid.tf 2>&1", 1)
    assert_match "file invalid.tf is not a valid Terraform file", output

    system bin/"tfsort", "valid.tofu"
    assert_equal (testpath/"expected.tofu").read, (testpath/"valid.tofu").read
  end
end
