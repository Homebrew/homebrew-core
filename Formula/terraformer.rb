class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.7.tar.gz"
  sha256 "8884528c84f2b70480f16e7c8a1f79e9723671415365b2bd36d21e5142eb4746"
  head "https://github.com/GoogleCloudPlatform/terraformer.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "045ad90cc346f6428ca0ea2427efa15737af6c3c236002a28f0fa00db65c8d1f" => :catalina
    sha256 "61649f3bd3ff1b3a27936db09b7de8554266806d8230ce6d3f19e3905470126f" => :mojave
    sha256 "20defa3cb71f9fb53a66c4af539f3ee58bf747529fbdae9493fd44125311a2c6" => :high_sierra
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
