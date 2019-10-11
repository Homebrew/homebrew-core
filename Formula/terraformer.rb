class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer.git",
    :tag      => "0.8.2",
    :revision => "48bfa60e9d30e25a110866f051ddb86f25c1c10c"

  bottle do
    cellar :any_skip_relocation
    sha256 "003a9592e59bd925fc68835ee011cbc7cdc3aa679b9f61c8cc6ca1fa8e6265fe" => :catalina
    sha256 "854f4bdc4b4fc4fd9eb04541036bbe5a4fc8df045ed845385a91dbdb743aedeb" => :mojave
    sha256 "016dca87bf2064cbcc5113a8563047d4cdc28c7d59dc64f6d1e2e220e0754af3" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

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
