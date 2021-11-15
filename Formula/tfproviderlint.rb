class Tfproviderlint < Formula
  desc "Terraform Provider Lint Tool"
  homepage "https://github.com/bflad/tfproviderlint"
  url "https://github.com/bflad/tfproviderlint/archive/v0.27.1.tar.gz"
  sha256 "92bbef65ccc2a2947e5dc8e0cfdf20d0485dbf87a21fbc10c865ff25210fb6a8"
  license "MPL-2.0"
  head "https://github.com/bflad/tfproviderlint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f3313965207d5d734a6bae3cf26ddfa13eacc242de91ba71d59c2df690f580f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f3313965207d5d734a6bae3cf26ddfa13eacc242de91ba71d59c2df690f580f"
    sha256 cellar: :any_skip_relocation, monterey:       "dcfad98559f94d55cb3f7113336cbdd2891b96f66ebedab2ba75704116e6737f"
    sha256 cellar: :any_skip_relocation, big_sur:        "dcfad98559f94d55cb3f7113336cbdd2891b96f66ebedab2ba75704116e6737f"
    sha256 cellar: :any_skip_relocation, catalina:       "dcfad98559f94d55cb3f7113336cbdd2891b96f66ebedab2ba75704116e6737f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e5f0cb5c419b1af23d92730e866b56a7693a7871d2e591bad7826df914d87a8"
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
    assert_match "tfproviderlint: ./... matched no packages",
      shell_output(bin/"tfproviderlint -fix ./... 2>&1", 1)

    testpath.install resource("test_resource")
    assert_match "S006: schema of TypeMap should include Elem",
      shell_output(bin/"tfproviderlint -fix #{testpath}/... 2>&1", 3)

    assert_match version.to_s, shell_output(bin/"tfproviderlint --version")
  end
end
