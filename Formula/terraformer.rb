class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer.git",
    :tag      => "0.8",
    :revision => "1604c897bf7c3ec2ca7c70c93453609070cd5d2b"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb641e815893d3b6e20f851f06ce232df1bc4fdb70bc1e449cbfa09500cf41af" => :catalina
    sha256 "c248ce5f7923118066ad2588567d8787f549a7a0a846f9c8e0e770201e699e33" => :mojave
    sha256 "403e29ef50b4dfe8ccc12e78b1ccdb1d5cdb0e142bd68dc63f470093a0423306" => :high_sierra
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
