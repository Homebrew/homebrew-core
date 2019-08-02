class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint/archive/v0.9.3.tar.gz"
  sha256 "cad7d122178175eff12dad349225b4feeb02e34e0f5c021d0d73cb694b04ceb2"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f19f4d642b40b59ebebd1996c9391458fa4936701211eeca81021aa39b3e4e4a" => :mojave
    sha256 "a9dd9f376ef66b90e18b074e96558f263293f464fc68b82b2b475d04a7096b4f" => :high_sierra
    sha256 "416baeeecbc612624e7fff6276b20ed71f1a65558b6c591771e1d64925b8e3c5" => :sierra
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
