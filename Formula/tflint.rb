class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint.git",
    :tag      => "v0.10.0",
    :revision => "fa42936c536b9cf2719cc98c675ae65e85ebfcb7"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "60a1defa4ec8b2d1a084d737886b455111f2519d9844629d43aafed0fc8c7d8e" => :mojave
    sha256 "413b1ee344f776e8e82ebb73372171bf946b0a049b86b342787c6b628f044c8a" => :high_sierra
    sha256 "015255a3b8a6f6ece61265af5de236e01c95b01b9fea06e57d4179db0aa7b76e" => :sierra
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
