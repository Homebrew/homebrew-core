class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer.git",
    :tag      => "0.7.6",
    :revision => "abca7f948bc7b82282646682d620b67bd264b889"

  bottle do
    cellar :any_skip_relocation
    sha256 "cfc63b42ced4a3b9b7f6e6487258100c03ae4f7e7dc574b6b5dceb7135efcee9" => :mojave
    sha256 "1811cbc5c59aaeec3ab972836240da115e75fa4ff588a94fbc780d0de10b85cb" => :high_sierra
    sha256 "c19ea7f9c303ed2c35ddaefb59358c791b3ddc5f5c6be5d3c42aea2d20de7861" => :sierra
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
