class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer.git",
    :tag      => "0.7.7",
    :revision => "48e126c29a98a8e3ecd9c9ee0bad334e42b35534"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce85ec1338fa54f8e3d23a0d3fcbbedcf8a91e2169b2f28d2458b12dd0754a26" => :mojave
    sha256 "f251743b7e4229639044a684d8b44fa971355882c2ea29a5133b8f8e90871eda" => :high_sierra
    sha256 "37e8c40ef278c1d679f0ad21250e64b8fb4eb75e96278c051dde868e57bffb2a" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/GoogleCloudPlatform/terraformer"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"terraformer"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terraformer version")

    help_output = "Available Commands"
    assert_match help_output.to_s, shell_output("#{bin}/terraformer -h")

    import_error = "aaa"
    assert_match import_error.to_s, shell_output("#{bin}/terraformer import google --resources=gcs --projects=aaa 2>&1", 1)
  end
end
