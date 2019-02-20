class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/heptio/velero"
  url "https://github.com/heptio/velero/archive/v0.11.0.tar.gz"
  sha256 "366f4c1ed5800dbdddefa60ed88bdd82b406b69b76a214b1d7108997a2f973ac"

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
