class Sshcode < Formula
  desc "Run VS Code on any server over SSH"
  homepage "https://github.com/cdr/sshcode"
  url "https://github.com/cdr/sshcode/archive/v0.8.0.tar.gz"
  sha256 "235dc537d8b2d1425a8c90fc9ccc1f404cd01a03c6c04f2e7f1a0b48521e59aa"

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    ENV["GO111MODULE"] = "on"
    sshcodepath = buildpath/"src/github.com/cdr/sshcode"
    sshcodepath.install buildpath.children

    cd "src/github.com/cdr/sshcode" do
      system "go", "build", "-o", "build/sshcode", "."
      bin.install "build/sshcode"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/sshcode", "--version"
  end
end
