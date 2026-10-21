class Tfsort < Formula
  desc "CLI to sort Terraform variables and outputs"
  homepage "https://github.com/AlexNabokikh/tfsort"
  url "https://github.com/AlexNabokikh/tfsort/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "51b2289ce553c42934842ab15841c9cb04cd125ff72a02aa83dc0e95bb346270"
  license "Apache-2.0"
  head "https://github.com/AlexNabokikh/tfsort.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "148699293097db6901bb4c26b53ebe409db49f85fe620ddfb4b17ca83e5160f0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "148699293097db6901bb4c26b53ebe409db49f85fe620ddfb4b17ca83e5160f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "148699293097db6901bb4c26b53ebe409db49f85fe620ddfb4b17ca83e5160f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "240c27729b3d52ad76f9011fed728f581fa3b6b8010b2be322b7ce899ae1c117"
    sha256 cellar: :any,                 x86_64_linux:      "f32581daf62183783cd0af5abaec81501fe335f276a2cbb284fd169f8c4ee9ff"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    # install testdata
    pkgshare.install "internal/hclsort/testdata"
  end

  test do
    cp_r pkgshare/"testdata/.", testpath

    assert_empty shell_output("#{bin}/tfsort invalid.tf 2>&1")

    system bin/"tfsort", "valid.tofu"
    assert_equal (testpath/"expected.tofu").read, (testpath/"valid.tofu").read
  end
end
