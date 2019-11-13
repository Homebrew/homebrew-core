class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://github.com/VirusTotal/vt-cli/archive/0.7.0.tar.gz"
  sha256 "39a566be0e2ee1102c0bd9d3ddefa4a0e423c9ffe02962d4a48897a875312c95"

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    repo = "github.com/VirusTotal/vt-cli"
    (buildpath/"src/#{repo}").install buildpath.children

    cd "src/#{repo}" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-ldflags",
             "-X #{repo}/cmd.Version=#{version}",
             "-o", bin/"vt", "./vt/main.go"
      prefix.install_metafiles
    end

    output = Utils.popen_read("#{bin}/vt completion bash")
    (bash_completion/"vt").write output

    output = Utils.popen_read("#{bin}/vt completion zsh")
    (zsh_completion/"_vt").write output
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end
