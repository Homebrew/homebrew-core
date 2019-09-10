class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint.git",
    :tag      => "v0.11.1",
    :revision => "1c31b742deb0a556520dec70ae9d4da5740f2b48"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ac6681b6cd4de2a379cdaee7a326ba2a0e49ddc2b477b537579df261246c723" => :mojave
    sha256 "a9bb879ef4fc895d9f798c746d1491d3ba633e98f965a7b9b4084090cdff1c83" => :high_sierra
    sha256 "7bc7551aa6357435b020632294ed2ef5091e94f9c902c071556dbecf0fd01013" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/wata727/tflint"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"tflint"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"test.tf").write <<~EOS
      provider "aws" {
        region = "${var.aws_region}"
      }
    EOS

    # tflint returns exitstatus: 0 (no issues), 2 (errors occured), 3 (no errors but issues found)
    assert_match "", shell_output("#{bin}/tflint test.tf")
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
