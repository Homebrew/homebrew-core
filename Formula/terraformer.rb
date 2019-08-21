class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer.git",
    :tag      => "0.7.8",
    :revision => "cf2f97dc3b2d6a7944a081512ddc6e5a60e921db"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0518f194b5764185d21123ab37dba7aefbb9d9d1faecbd263a0cf98a723cd7e" => :mojave
    sha256 "6d5f4ea9abec8a0d2a593a6ffac87e7fa150aba8a5b72b17ff818620a0a81ef3" => :high_sierra
    sha256 "01288b1442e74e4a5b052961d482809ac372362d6c08209e95254eedb89a9e31" => :sierra
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
