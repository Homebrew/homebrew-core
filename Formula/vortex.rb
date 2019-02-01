class Vortex < Formula
  desc "The light weight version of helm. KISS Kubernetes interpolation."
  homepage "https://github.com/AlexsJones/vortex"
  url "https://github.com/AlexsJones/vortex/archive/v0.1.0-alpha.tar.gz"
  sha256 "f2ccf4348b004708892bc269e18139f0313ac9dbe64275be1b8a9843605b035e"

  depends_on "go" => :build
  depends_on "dep" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"

    dir = buildpath/"src/github.com/AlexsJones/vortex"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
        ENV["CGO_ENABLED"] = "0"
        ENV["GOOS"] = "darwin"
        system "dep", "ensure"
        system "go", "build", "--ldflags='-s -w'", "-o", "pkg/darwin_amd64/vortex"

        bin.install "pkg/darwin_amd64/vortex"
        prefix.install_metafiles
    end
  end
end
