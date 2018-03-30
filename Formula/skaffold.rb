class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleCloudPlatform/skaffold"
  url "https://github.com/GoogleCloudPlatform/skaffold.git",
      :tag => "v0.3.0",
      :revision => "0e9951cbab558661dcd189a0ccd8ed1d13a402f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "90a45919a549309411996f54bbc14e16ce9214368db29b641b5be04683cdce76" => :high_sierra
    sha256 "972ea47fa683d24d5aaf96ed2dae6894e1ee577949ed4fb33b2bd921927badb4" => :sierra
    sha256 "87082e3b8a369de119704e6089b9e0b8f3063cc7560f520e7e665bce4fbe2c93" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/GoogleCloudPlatform/skaffold"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "make"
      bin.install "out/skaffold"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/skaffold version --output {{.GitTreeState}}")
    assert_match "clean", output
  end
end
