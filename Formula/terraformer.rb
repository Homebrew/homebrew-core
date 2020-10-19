class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.9.tar.gz"
  sha256 "42f3b5cb9d7fead1f7e24a1a33adabd0f9e46f8df95924bc358d1fa699c82c7b"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/terraformer.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "53df2cdffb11c12ff3ce2e4109081dd3ebff068ecc7583cd7e06638d83b4977f" => :catalina
    sha256 "6fcf60a7fdb7883260048b568f1a1cfd6ee67613057b6ca3bbe522e1997a2005" => :mojave
    sha256 "d47a5ae40b454e3304f1cc804e71dc6598dc234fd504dcc84242e6831be6cffb" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/terraformer version")

    assert_match "Available Commands",
      shell_output("#{bin}/terraformer -h")

    assert_match "aaa",
      shell_output("#{bin}/terraformer import google --resources=gcs --projects=aaa 2>&1", 1)
  end
end
