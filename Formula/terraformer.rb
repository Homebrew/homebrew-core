class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer.git",
    :tag      => "0.7.9",
    :revision => "44622c926810d5dc82a348c1c9bbc59e936dcd39"

  bottle do
    cellar :any_skip_relocation
    sha256 "761ebe37fe50cdb9093650133de13c07d7374ce1ac147fd19e609a021c570b39" => :mojave
    sha256 "c5aff73f555acce0028b63802ad57beef5fa7b0d4c37a644953df0326cdeea29" => :high_sierra
    sha256 "b67f37bcf1e45c987eac0bc068596bde728959bbd4302601faa38fe9e6e6d4e0" => :sierra
  end

  depends_on "go" => :build

  # Should be removed in the next release
  patch do
    url "https://github.com/GoogleCloudPlatform/terraformer/pull/179/commits/75b3b4620d18c1ef7ac4ee3e0fa7062f0535fa48.patch?full_index=1"
    sha256 "b75e9d4e63c1601fe769a15f973cd9517d18bdef5b430c280bf2c57f2d5a3b0f"
  end

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
