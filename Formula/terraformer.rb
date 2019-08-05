class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer.git",
    :tag      => "0.7.7",
    :revision => "48e126c29a98a8e3ecd9c9ee0bad334e42b35534"

  bottle do
    cellar :any_skip_relocation
    sha256 "386a8311495f73d809ac24e2193041c1491f162a3ecdb48640d37917fd14fe7f" => :mojave
    sha256 "9805bb751832f8247bef7926bf2742989692dc8c2532bc02b8ddf175b07eede3" => :high_sierra
    sha256 "342aa3f247b34f52ed7fdc8bb8c48ec013d4159cee5c95df7b12afb8d22e6563" => :sierra
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
