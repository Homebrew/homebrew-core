class Tfsort < Formula
  desc "CLI to sort Terraform variables and outputs"
  homepage "https://github.com/AlexNabokikh/tfsort"
  url "https://github.com/AlexNabokikh/tfsort/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "abd7b505e02f595d328fd675ceb8d782481fb8a5073dfd9a51a4e09516c9206a"
  license "Apache-2.0"
  head "https://github.com/AlexNabokikh/tfsort.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ae02861966697f33cbffa601b67694a2323c2cf92f6fc6bf1283f632f97c564e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ae02861966697f33cbffa601b67694a2323c2cf92f6fc6bf1283f632f97c564e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ae02861966697f33cbffa601b67694a2323c2cf92f6fc6bf1283f632f97c564e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c05793344f09bd39e72908a00a02bd909257dc2ac98cc583cfe9fd47809bc64e"
    sha256 cellar: :any,                 x86_64_linux:      "d2ea6f9c401e1393a221fba81b6e44d89a086dcd9b2cc54791c923e02f123a33"
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
