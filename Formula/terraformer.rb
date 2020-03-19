class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer.git",
    :tag      => "0.8.6",
    :revision => "74c74efbddac0489cb7d4e6f3ccbc01025be754f"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c67c3ecbbb4e4ac66fb66830d66885baea402a344c8cf2891b3aeb97b128ee2" => :catalina
    sha256 "cb69b365b97b950e2a8a8760851a977eca26c4f79272fc76d241fc8c9b1ed4c5" => :mojave
    sha256 "a33f2d84ee398e8e5cc90d0dd1506396f7c869f43fe10677ec4725ff359aeff2" => :high_sierra
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
    assert_match version.to_s,
      shell_output("#{bin}/terraformer version")

    assert_match "Available Commands",
      shell_output("#{bin}/terraformer -h")

    assert_match "aaa",
      shell_output("#{bin}/terraformer import google --resources=gcs --projects=aaa 2>&1", 1)
  end
end
