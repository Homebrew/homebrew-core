class Yaml < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yaml"
  url "https://github.com/mikefarah/yaml/archive/1.13.1.tar.gz"
  sha256 "5512c586c6dd4f9b838d80facde656153b4fe3c1ce4992cc3057f0930fec4c7a"

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/mikefarah/yaml").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    cd gopath/"src/github.com/mikefarah/yaml" do
      system "govendor", "sync"
      system "go", "build", "-o", "bin/yaml"
      bin.install "bin/yaml"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "key: cat", shell_output("#{bin}/yaml n key cat")
    assert_match "cat", pipe_output("#{bin}/yaml r - key", "key: cat", 0)
  end
end
