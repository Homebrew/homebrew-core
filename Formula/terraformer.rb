class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer/archive/0.8.8.tar.gz"
  sha256 "a9cabe0889ebf823abb552f6e24276a8bf7667923918814623fe5129c34f47f0"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/terraformer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8df5d868473fa864a82e2c643257317565b4329472e1e3f1abd5d57c370eef6" => :catalina
    sha256 "1f2329c2ab0200adadb0a83e1073ff6e38984cbbee74450f62649c61734cf618" => :mojave
    sha256 "b9fbd65c0319b54db123e71062ab23d85c01c9200e0cf7d8b460302a78565660" => :high_sierra
  end

  depends_on "go" => :build

  # fix version check, remove in next release
  # https://github.com/GoogleCloudPlatform/terraformer/pull/535
  patch do
    url "https://github.com/GoogleCloudPlatform/terraformer/commit/3f75098f9e85e9630af5c4e0baa6529e52b0efb5.patch?full_index=1"
    sha256 "477581bc9a3be36427e181d2ccdcefcbf13b9230b8ddf5e9eea64de9357a6274"
  end

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
