class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer.git",
    :tag      => "0.8.4",
    :revision => "3df9db7f4811e89d2633e78c3fd4743ec0062d4f"

  bottle do
    cellar :any_skip_relocation
    sha256 "7197e3ecc256aff6efb2e8d186a5507270431f4d0f37735e24aa3d29c76a9bb5" => :catalina
    sha256 "0a9c047c5429ff44af7b0f8451b38f8b966f193ddb073e9c6ca3105d84498f0c" => :mojave
    sha256 "7174d86df23c114fd2e3d92fc8d0172631011e4e725334e32e8fe3ec04245749" => :high_sierra
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
