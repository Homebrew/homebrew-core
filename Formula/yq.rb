class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v2.2.0.tar.gz"
  sha256 "cae447da53393bc7a61cf7a6411f6c9b9a9a82b4f6bb366a98dca233ef9ac42e"

  bottle do
    cellar :any_skip_relocation
    sha256 "cad5b210852e4beece0c46eff349de57c62fd2ed2e8a4ac2b9283fb054e2f6fe" => :mojave
    sha256 "532b7c852ca3c5468daaf75ef0158a74768639169609fb55f3f735955a877901" => :high_sierra
    sha256 "810cc2ebcae5f46ef60cceac883ec1db0695d76b51563471e288f6fdc93ed414" => :sierra
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  conflicts_with "python-yq", :because => "both install `yq` executables"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/mikefarah/yq").install buildpath.children

    cd "src/github.com/mikefarah/yq" do
      system "govendor", "sync"
      system "go", "build", "-o", bin/"yq"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq n key cat").chomp
    assert_equal "cat", pipe_output("#{bin}/yq r - key", "key: cat", 0).chomp
  end
end
