require "open3"

class Riff < Formula
  desc "Function As A Service on top of Kubernetes, riff is for functions"
  homepage "https://www.projectriff.io/"
  url "https://github.com/projectriff/cli.git",
      :tag      => "v0.4.0",
      :revision => "d1b042f4247d8eb01ee0b9e984926028a2844fe8"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebe82f4eb5de8ec1f5047f7f69514cb69296040006fd1730e1e0eb097655186e" => :mojave
    sha256 "fde0709788f1f8ee61d9a9cc9759029b4fd43b3a4d30bda206d36e54ef644750" => :high_sierra
    sha256 "51e7e1cbb9df115a3e169c7419ce1361b2050d3c2d4d564d69a177593fad3486" => :sierra
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
    stdout, stderr, status = Open3.capture3("#{bin}/riff --kube-config not-a-kube-config-file doctor")

    assert_equal false, status.success?
    assert_equal "", stdout
    assert_match "panic: stat not-a-kube-config-file: no such file or directory", stderr
  end
end
