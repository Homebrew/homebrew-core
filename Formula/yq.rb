class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v3.1.0.tar.gz"
  sha256 ""

  bottle do
    cellar :any_skip_relocation
    sha256 "47d1491e39b2dbdde12e25c598d8c91ccf6e1f83a741666af4e6b6356da95140" => :catalina
    sha256 "b585bfc44f587c7b5debed24fb9a4fa6f05a5b908a6a305aa858a02d1aa20223" => :mojave
    sha256 "57a3a809d48902c2cc4f0cbc9d959775cbf0de7faaceda46689626d92b55abd5" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "python-yq", :because => "both install `yq` executables"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/mikefarah/yq").install buildpath.children

    cd "src/github.com/mikefarah/yq" do
      system "go", "build", "-o", bin/"yq"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq n key cat").chomp
    assert_equal "cat", pipe_output("#{bin}/yq r - key", "key: cat", 0).chomp
  end
end
