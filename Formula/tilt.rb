class Tilt < Formula
  desc "Local Kubernetes development with no stress"
  homepage "https://tilt.build/"
  url "https://github.com/windmilleng/tilt/archive/v0.5.1.tar.gz"
  sha256 "a5f33bbdaca92a7842f5f056fe30260cbb9412deca71634a81596dd981ce5399"

  depends_on "go" => :build
  depends_on "docker"
  depends_on "kubernetes-cli"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"

    (buildpath/"src/github.com/windmilleng").mkpath
    ln_s buildpath, "src/github.com/windmilleng/tilt"

    system "go", "build", "-o", bin/"tilt", "github.com/windmilleng/tilt/cmd/tilt"
    system "go", "build", "-o", bin/"synclet", "github.com/windmilleng/tilt/cmd/synclet"
  end

  test do
    system bin/"tilt", "version"
  end
end
