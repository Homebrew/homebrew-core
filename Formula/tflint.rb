class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint/archive/v0.9.2.tar.gz"
  sha256 "ba34b6ce3b4a525f3d3af0cd1a96322e0acbc90a6db11ea45c5e9c2579b685ab"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "99110c6d7310a93a4d3c9f45b9bc267a748be06503fb6123c0f563d42b91e603" => :mojave
    sha256 "12ad24bd01528b1f1063abbaad0eaa5c2ba8d11612fb28179311c5afe3cc1285" => :high_sierra
    sha256 "723e9d1357d02c7cedf50657b06c82ff34d9f09dc1f3674664734e0a2915528c" => :sierra
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
