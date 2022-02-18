class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.56.2.tar.gz"
  sha256 "e435fbd3a29447fa69ac9ff151159a385e08f4b2e63f33e20e73b8d22071f440"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6e7f4eaf07691b70b73093e578a76715118e808b158325f6cd6353d8de24db8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a3a45feb3237190c37c612859418b83347039a1104677406a6302dad361d76e"
    sha256 cellar: :any_skip_relocation, monterey:       "a2b4bbbaa9b29610bc4ba2af6460d12380385269e5ac3ea705133f477d7cf8fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "510f3e21d5b942f86972312fc4a3eb35847cd3de46b2912a4a78e7f91ed4b478"
    sha256 cellar: :any_skip_relocation, catalina:       "9b3642428c30dfcb2d0149d6e131aa820a576eb8725faac7889d1df724df1317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a67cc85abfac96616b5749ea89e88b46c9fe5981e85dd9adbba5996fb87bc3a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vmware-tanzu/sonobuoy/pkg/buildinfo.Version=v#{version}")
  end

  test do
    assert_match "Sonobuoy is a Kubernetes component that generates reports on cluster conformance",
      shell_output("#{bin}/sonobuoy 2>&1")
    assert_match version.to_s,
      shell_output("#{bin}/sonobuoy version 2>&1")
    assert_match "name: sonobuoy",
      shell_output("#{bin}/sonobuoy gen --kubernetes-version=v1.21 2>&1")
  end
end
