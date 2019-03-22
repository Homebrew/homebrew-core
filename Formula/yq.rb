class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/2.3.0.tar.gz"
  sha256 "57aba2c73316d0bcdc7afb159e55f3d1f4aaf0de124b98c055d3cb0aca013ac3"

  bottle do
    cellar :any_skip_relocation
    sha256 "df3800c9c1086face2ac44ee905d58345749e75f8cb916e57f357a05e14ac12b" => :mojave
    sha256 "65b1e379cb5e259ff5214a01b63f6390a00c99628b80a70f42e0e17bf41cdee1" => :high_sierra
    sha256 "5996613c6c5a0ad377aaffd16ac9d003b45aa652ac42213971123921e7f767b2" => :sierra
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
