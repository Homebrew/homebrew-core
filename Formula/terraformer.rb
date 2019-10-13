class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer.git",
    :tag      => "0.8.3",
    :revision => "126bc5d271d297c2613d014e39d66503fc43173d"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0b56ebc83cc07e4e479c108dcbe36f99bbec54da90e323948c246ae86f39f9e" => :catalina
    sha256 "180e98e786069a0a4c9169af2fd0d92f878bd02fbbde9b411a2f6731b5e69ac4" => :mojave
    sha256 "65dbb3a3c29928da15da70fe44b5289906a5e6c451376a7e13d6ab45753df935" => :high_sierra
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
