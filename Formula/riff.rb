require "open3"

class Riff < Formula
  desc "Function As A Service on top of Knative, riff is for functions"
  homepage "https://www.projectriff.io/"
  url "https://github.com/projectriff/riff.git",
      :tag      => "v0.3.0",
      :revision => "4e474f57a463d4d2c1159af64d562532fcb3ac1b"

  bottle do
    cellar :any_skip_relocation
    sha256 "5bef8143a90ebbe86f3cad7fa8a59060bbf14fd67f7f40cc044a64c218339e1a" => :mojave
    sha256 "7afdf4d5a372ee7b8240720263c8325107ec31ae9cdec31d6661a4e9a91f706a" => :high_sierra
    sha256 "7444641e6d557b789651ab759aa46d27c4faf84087ef39ee4313ab8f9ff60da4" => :sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    cd buildpath do
      system "make", "build"
      bin.install "riff"
    end
  end

  test do
    stdout, stderr, status = Open3.capture3("#{bin}/riff --kubeconfig not-a-kube-config-file service list")

    assert_equal false, status.success?
    assert_match "List service resources", stdout
    assert_match "Error: stat not-a-kube-config-file: no such file or directory", stderr
  end
end
