class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/terraformer.git"

  stable do
    url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.8.tar.gz"
    sha256 "a9cabe0889ebf823abb552f6e24276a8bf7667923918814623fe5129c34f47f0"

    # fix version check, remove in next release
    # https://github.com/GoogleCloudPlatform/terraformer/pull/535
    patch do
      url "https://github.com/GoogleCloudPlatform/terraformer/commit/3f75098f9e85e9630af5c4e0baa6529e52b0efb5.patch?full_index=1"
      sha256 "477581bc9a3be36427e181d2ccdcefcbf13b9230b8ddf5e9eea64de9357a6274"
    end
  end

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
