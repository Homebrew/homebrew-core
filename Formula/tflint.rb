class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint.git",
    :tag      => "v0.10.3",
    :revision => "1ba6a7adf3128ebe4449f063519b22a821b462f1"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "18a8cb7708043553cfb34a7862a5ce92c49a2059bfc4c29b3017c98b2e1a7e05" => :mojave
    sha256 "13a273b940bb2f5ab2478f7584003fcc861b839f56b7b6879291705cf33d3e33" => :high_sierra
    sha256 "3ef5d2bde2f191cf1bf111cebd8e30a84acba5dd1b4c6c9be5bc566ecc99d961" => :sierra
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
    assert_match "Awesome! Your code is following the best practices :)", shell_output("#{bin}/tflint test.tf")
  end
end
