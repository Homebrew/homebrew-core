class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint.git",
    :tag      => "v0.10.3",
    :revision => "1ba6a7adf3128ebe4449f063519b22a821b462f1"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d63067f1ddd611e8c86554bf5eaa51b45b3dddc2a9955c90bc12c6451db7d20" => :mojave
    sha256 "fdba960e7e5bf7e279fad42faf90441dd8e942eb73acd573869a58077b4d5a81" => :high_sierra
    sha256 "a0c8bff05cf75d62b64964d2c4f289ae796731e84dd4103678977dc104428398" => :sierra
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
