class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/3.2.1.tar.gz"
  sha256 "91aad8002532f6dc236fb6edf3a200e37fb1efc038a880606fe96927e3a64fc4"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cbb0eda1f9d8c20342c41979e2cca5440e6215e85c36a3f29983f567557449a" => :catalina
    sha256 "da0fed59609ef76d81b7b206a82f202827db2b19a2110b1978e0a2468c3a9e93" => :mojave
    sha256 "40499ec3e93128d1a049f75bb43dc20bd256f3135b4b06b54b5c62f446f01c46" => :high_sierra
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
