class Sonobuoy < Formula
  desc "Diagnostic tool that makes it easier to understand the state of a Kubernetes cluster by running a set of Kubernetes conformance tests in an accessible and non-destructive manner"
  homepage "https://github.com/heptio/sonobuoy"
  url "https://github.com/heptio/sonobuoy/archive/v0.12.0.tar.gz"
  sha256 "068def4fedb8d9a951444a83759a9c3eafef7b968a3d8b1135f63ff982571fdf"

  bottle do
    cellar :any_skip_relocation
    sha256 "" => :mojave
    sha256 "" => :high_sierra
    sha256 "" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/heptio/sonobuoy").install buildpath.children

    cd "src/github.com/heptio/sonobuoy" do
      system "go", "build", "-o", bin/"sonobuoy", "-installsuffix", "static",
                   "-ldflags",
                   "-X github.com/heptio/sonobuoy/pkg/buildinfo.Version=#{version}",
                   "./cmd/sonobuoy"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/sonobuoy 2>&1")
    assert_match "Sonobuoy is an introspective kubernetes component that generates reports on cluster conformance", output
    assert_match "#{version}", shell_output("#{bin}/sonobuoy version 2>&1")
    output = shell_output("#{bin}/sonobuoy gen 2>&1")
    assert_match "name: heptio-sonobuoy", output
  end
end
