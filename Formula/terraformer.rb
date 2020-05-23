class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.7.tar.gz"
  sha256 "8884528c84f2b70480f16e7c8a1f79e9723671415365b2bd36d21e5142eb4746"
  head "https://github.com/GoogleCloudPlatform/terraformer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "535df4b5e6cff30a332591370f4369398557b2c8c0a5f3217e54018bdd1f26a8" => :catalina
    sha256 "d96f59a3eadc4c6ec1c1a825ccc9a806f8a3398987018a691cc67d5515f45464" => :mojave
    sha256 "2d33a7d2395698fab431d79fc63268341fa7aaea14f5d6cd89d64962ba7feb5e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    prefix.install_metafiles
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
