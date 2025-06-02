class Tfsort < Formula
  desc "CLI to sort Terraform variables and outputs"
  homepage "https://github.com/AlexNabokikh/tfsort"
  url "https://github.com/AlexNabokikh/tfsort/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "efbbb75b44d0a48e0871d6955c11d7210207b3d752c99d34c48468e4c2c8fe76"
  license "Apache-2.0"
  head "https://github.com/AlexNabokikh/tfsort.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9737612cc507fec8f0d4bb798459c93baa49bad0033efb14b8b3c35b4f8a40a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9737612cc507fec8f0d4bb798459c93baa49bad0033efb14b8b3c35b4f8a40a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9737612cc507fec8f0d4bb798459c93baa49bad0033efb14b8b3c35b4f8a40a"
    sha256 cellar: :any_skip_relocation, sonoma:        "70f710aca494baee390f28361c16e5950e7312be1fe0a6a9240a4023541edbd5"
    sha256 cellar: :any_skip_relocation, ventura:       "70f710aca494baee390f28361c16e5950e7312be1fe0a6a9240a4023541edbd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bf69d5c5b2eea64283a955cb12409fa20bb42123933f4da61da2658915969f8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
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
