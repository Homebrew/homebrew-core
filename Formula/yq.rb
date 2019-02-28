class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v2.2.1.tar.gz"
  sha256 "f0522bfd3adaf4cc3fc45b2faee7656b156324bff01f563737f39f5519fe76dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "f05fa62d2b6e88ced64f2478ad0b6517169a571eed2f7d1417ff9bc7517690ac" => :mojave
    sha256 "1744d684a097b428c39247b6cb6df18d0e9c0af16129cfa78a5ac87766c6a989" => :high_sierra
    sha256 "b559683e93fcdd61b40366505005cbb6877d4b1349035413ac00fcc31aed7ccf" => :sierra
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
