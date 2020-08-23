class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/3.3.2.tar.gz"
  sha256 "28b34199aadafe0eef1e7becc6953675ad516383b31637a42080940e1c9318fb"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1cd476d249fd7a11034e3e8581a099cc8dfff09cc1ff40c79b819a5562399137" => :catalina
    sha256 "7b33668ea6670cc65b4ef92d640c0066d9fc0c54f7bea4136cd326d8b59d37e8" => :mojave
    sha256 "d59fe8d26fa97d6fc26bfff73315d90d361e456bdecf1fdfc10084c3cadedd30" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

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
