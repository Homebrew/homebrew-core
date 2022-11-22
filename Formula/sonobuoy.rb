class Sonobuoy < Formula
  desc "Kubernetes component that generates reports on cluster conformance"
  homepage "https://github.com/vmware-tanzu/sonobuoy"
  url "https://github.com/vmware-tanzu/sonobuoy/archive/v0.56.12.tar.gz"
  sha256 "feab53ede72d71f96c3934b85e64cc0a2a490bd5772de1cdd4166ff52a0c95bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d08df0e55fcc88ed437ce6984a10b379d9623be7b16c38a13aea29a29265ecf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56c1907194cc55fb13076301ce76a6d64eae68a84fce6cb3195d2c2eb380bd3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00bde29adcfc21151c2424374027f5fa8e659deabaae96fac2893b317a48322a"
    sha256 cellar: :any_skip_relocation, monterey:       "909e55c0ac2c65eb5daaf3806bd0643379ed093e2811b95ffb4a7ed1a8397bee"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5ced62a636e877be78b28ed7eaaf081e93b88f0a24e908614f8e824e03a0b43"
    sha256 cellar: :any_skip_relocation, catalina:       "ad6ca3e70a9b6d183972bdfc45d1612e1969e34c38dabcf3237eaefe33ebcf96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4f644c3bff042b99f076d3b590ab44f2e14ed89ab93c0571d29583afedee5e6"
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
