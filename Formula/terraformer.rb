class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer.git",
    :tag      => "0.7.4",
    :revision => "e2dba7410c90d887918fa36eedace8c555115a47"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fc251c6c6b88a7f6878aaba2d28a5eda6d86356d59eebcf6b508f8485b75910" => :mojave
    sha256 "8d35fd49630cd0ae536c1239f2a8a79ddac03e776f9f1c8770117b80dc52c8ba" => :high_sierra
    sha256 "6dd19a2e9adc5140690cbbf1ac468b817d63281df612e4df7e60aa2ad1e85cdb" => :sierra
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
    assert_match import_error.to_s, shell_output("#{bin}/terraformer import google --resources=gcs --zone=europe-west1-a --projects=aaa 2>&1", 1)
  end
end
