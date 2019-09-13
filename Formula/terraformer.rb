class Terraformer < Formula
  desc "CLI tool to generate terraform files from existing infrastructure"
  homepage "https://github.com/GoogleCloudPlatform/terraformer"
  url "https://github.com/GoogleCloudPlatform/terraformer.git",
    :tag      => "0.7.9",
    :revision => "44622c926810d5dc82a348c1c9bbc59e936dcd39"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0518f194b5764185d21123ab37dba7aefbb9d9d1faecbd263a0cf98a723cd7e" => :mojave
    sha256 "6d5f4ea9abec8a0d2a593a6ffac87e7fa150aba8a5b72b17ff818620a0a81ef3" => :high_sierra
    sha256 "01288b1442e74e4a5b052961d482809ac372362d6c08209e95254eedb89a9e31" => :sierra
  end

  depends_on "go" => :build

  # Should be removed in the next release
  patch do
    url "https://github.com/GoogleCloudPlatform/terraformer/pull/179/commits/75b3b4620d18c1ef7ac4ee3e0fa7062f0535fa48.patch?full_index=1"
    sha256 "b75e9d4e63c1601fe769a15f973cd9517d18bdef5b430c280bf2c57f2d5a3b0f"
  end

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
