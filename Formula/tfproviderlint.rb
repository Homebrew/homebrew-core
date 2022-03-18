class Tfproviderlint < Formula
  desc "Terraform Provider Lint Tool"
  homepage "https://github.com/bflad/tfproviderlint"
  url "https://github.com/bflad/tfproviderlint/archive/v0.28.1.tar.gz"
  sha256 "df66a164256ffbacbb260e445313c0666bb14ce4b8363f123903259ecc0f4eb5"
  license "MPL-2.0"
  head "https://github.com/bflad/tfproviderlint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed11a7f3ceed09f207dd9625c2c5d1209aad1c0669b08ea3a526ba01e75cc6d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed11a7f3ceed09f207dd9625c2c5d1209aad1c0669b08ea3a526ba01e75cc6d2"
    sha256 cellar: :any_skip_relocation, monterey:       "2e0026ad21a957b1c081f57bcb8d288d25e1d87dc4a306a88574907922ffa6b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e0026ad21a957b1c081f57bcb8d288d25e1d87dc4a306a88574907922ffa6b5"
    sha256 cellar: :any_skip_relocation, catalina:       "2e0026ad21a957b1c081f57bcb8d288d25e1d87dc4a306a88574907922ffa6b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "454ab4aa8c42595a9e9d3a6cc3a3658f4d76f3cff47a2e0934cccb34a2f498fb"
  end

  depends_on "go" => [:build, :test]

  resource "test_resource" do
    url "https://github.com/russellcardullo/terraform-provider-pingdom/archive/v1.1.3.tar.gz"
    sha256 "3834575fd06123846245eeeeac1e815f5e949f04fa08b65c67985b27d6174106"
  end

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/bflad/tfproviderlint/version.Version=#{version}
    ]

    ldflags << if build.head?
      "-X github.com/bflad/tfproviderlint/version.VersionPrerelease=dev"
    else
      "-X github.com/bflad/tfproviderlint/version.VersionPrerelease="
    end

    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "./cmd/tfproviderlint"
  end

  test do
    testpath.install resource("test_resource")
    assert_match "S006: schema of TypeMap should include Elem",
      shell_output(bin/"tfproviderlint -fix #{testpath}/... 2>&1", 3)

    assert_match version.to_s, shell_output(bin/"tfproviderlint --version")
  end
end
