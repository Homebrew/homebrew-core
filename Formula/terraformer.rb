class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer.git",
    :tag      => "0.8.2",
    :revision => "48bfa60e9d30e25a110866f051ddb86f25c1c10c"

  bottle do
    cellar :any_skip_relocation
    sha256 "18421fb4d7f51bfabd5f715f6e41216b377f787b194c911054cf5cd78a3ed184" => :catalina
    sha256 "3d7aef41e3896a37c954f9c776fbc305278ea6078e81f7d0ef0ba2ddc74511d9" => :mojave
    sha256 "acfcf5fe1b7d6fee0ecebe2661bedb3f1d895522a2e332c559f9837f4633820d" => :high_sierra
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
