require "open3"

class Riff < Formula
  desc "Function As A Service on top of Knative, riff is for functions"
  homepage "https://www.projectriff.io/"
  url "https://github.com/projectriff/riff.git",
      :tag      => "v0.3.1",
      :revision => "1ff6c6d7a708e52eb6843e89f9a618fcbfebbb9f"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ef5559484851d1f28cd7f56b5cf0d88195378f3c9133001a0364445c5481877" => :mojave
    sha256 "0e8406d6c8bfd1ff1626b7205b81cbcb23684ba500eb83532b67401de2bf70d7" => :high_sierra
    sha256 "b68904bdb3b97e33541de373a7add5783400145f417e42561cae8dff74cd05ef" => :sierra
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
