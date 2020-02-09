class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/3.1.0.tar.gz"
  sha256 "dcb9c3d4f4acf5be29ae547b76a8ff67b6f994760d5adad22691132bae3ff490"

  bottle do
    cellar :any_skip_relocation
    sha256 "b36570800e4df9a0cf06667bc6729f8e1ab35318432b7b44390020ce1ce408d7" => :catalina
    sha256 "b2dce4003a1d472a09067d9ff3354d662500b980239b04933477a61d5edd82cb" => :mojave
    sha256 "c194b6e1cee8219fce85e3d94a6931bcff847ff21f6334dcf88a4f9ca05901df" => :high_sierra
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
