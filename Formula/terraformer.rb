class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer.git",
    :tag      => "0.8.5",
    :revision => "34b640d50cd5bef287237c8890af55dc73bb136e"

  bottle do
    cellar :any_skip_relocation
    sha256 "178deb67ec04ce1956e505ef2c03a8c443bb8bdeed698a7858f487b3a7a53e3b" => :catalina
    sha256 "74d985028d26d8994debb214dbc17e0a7b51236daaaece0e5d23e2b4eac6c260" => :mojave
    sha256 "e7b809c07e1c53f565cd686533c06a08db5e4c74cf938fd5bd9322ee89cd7403" => :high_sierra
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
