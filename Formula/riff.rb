require "open3"

class Riff < Formula
  desc "Function As A Service on top of Knative, riff is for functions"
  homepage "https://www.projectriff.io/"
  url "https://github.com/projectriff/riff.git",
      :tag      => "v0.2.0",
      :revision => "1ae190ff3c7edf4b375ee935f746ebfd1d8eaf5c"

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["GOPATH"] = buildpath
    contents = Dir["{*,.git,.gitattributes,.gitignore,.travis.yml}"]
    (buildpath/"src/github.com/projectriff/riff").install contents

    cd "src/github.com/projectriff/riff" do
      system "make", "build"
      bin.install "riff"
    end
  end

  test do
    stdout, stderr, status = Open3.capture3("#{bin}/riff --kubeconfig not-a-kube-config-file channel list")

    assert_equal false, status.success?
    assert_match "List channels", stdout
    assert_match "Error: stat not-a-kube-config-file: no such file or directory", stderr
  end
end
