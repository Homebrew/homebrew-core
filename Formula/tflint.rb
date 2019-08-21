class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint.git",
    :tag      => "v0.10.1",
    :revision => "a85ddd727dbf7807f7a50d73805027b27bad6f28"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "41f10b26f6d981cbaa0c7b4ab617825187bbd9082b093bc2b22e426f556beda6" => :mojave
    sha256 "b05f2f021c51279ffc90a43149f9b5b97ff71d55a41ccb9b3fc36fd005903dde" => :high_sierra
    sha256 "53fd4ab7ae7b6db4a5ac43b220ef95c171b0693baf94a311b3a2da6db9a804be" => :sierra
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
