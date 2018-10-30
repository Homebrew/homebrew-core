class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/2.1.2.tar.gz"
  sha256 "d0734b935be63e6585f73568f66ad3d967ddac6a4d41a73cc6feeea2d61b54f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e29166336ab371a3d42fb12f548642fd8a82e6e45fe6c5667197604540b2d31" => :mojave
    sha256 "71c45044c484d75a7a6f6990fafb81ea00a629a7e9431f21f7ecfa847e733ebf" => :high_sierra
    sha256 "2fa1a39829cfe39f5cdac1e256d4b2f958bbf3b41f282ff156f638e38b0f9dd5" => :sierra
    sha256 "5ddee8d32af2a9b5013dfa36b5fcc3bb25a11faa444d2163b479455d67722a74" => :el_capitan
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
