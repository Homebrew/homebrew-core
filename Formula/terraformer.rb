class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer.git",
    :tag      => "0.8",
    :revision => "1604c897bf7c3ec2ca7c70c93453609070cd5d2b"

  bottle do
    cellar :any_skip_relocation
    sha256 "761ebe37fe50cdb9093650133de13c07d7374ce1ac147fd19e609a021c570b39" => :mojave
    sha256 "c5aff73f555acce0028b63802ad57beef5fa7b0d4c37a644953df0326cdeea29" => :high_sierra
    sha256 "b67f37bcf1e45c987eac0bc068596bde728959bbd4302601faa38fe9e6e6d4e0" => :sierra
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
