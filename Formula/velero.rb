class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/heptio/velero"
  url "https://github.com/heptio/velero/archive/v0.11.0.tar.gz"
  sha256 "366f4c1ed5800dbdddefa60ed88bdd82b406b69b76a214b1d7108997a2f973ac"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe9cf23132d9c9920fd26749ec96784df10671caf6d601cf1eeda3767ca799dd" => :mojave
    sha256 "60a4d0fbacd56890542f2fea48ce779cad85cb5aa4686043865f3410bc5b5b47" => :high_sierra
    sha256 "32eab0a60cd6c568f5784012318a7c3bc3d4bf7739ba9f358a270b839d0724bf" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/heptio/velero").install buildpath.children

    cd "src/github.com/heptio/velero" do
      system "go", "build", "-o", bin/"velero", "-installsuffix", "static",
                   "-ldflags",
                   "-X github.com/heptio/velero/pkg/buildinfo.Version=#{version}",
                   "./cmd/velero"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/velero 2>&1")
    assert_match "Velero is a tool for managing disaster recovery", output
    assert_match "Version: #{version}", shell_output("#{bin}/velero version --client-only 2>&1")
    system bin/"velero", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/velero client config get 2>&1")
  end
end
