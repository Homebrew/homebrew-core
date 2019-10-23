class Virgil < Formula
  desc "CLI tool to manage your Virgil account and applications"
  homepage "https://github.com/VirgilSecurity/virgil-cli"
  url "https://github.com/VirgilSecurity/virgil-cli.git",
     :tag      => "v5.1.5",
     :revision => "ddf822a750cf43e2d1e953bd36b6770ec098f88b"
  head "https://github.com/VirgilSecurity/virgil-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b2f771af64c7b8827ed627334e5658ebf8a03c7de66cd8454a19edfb5a00f4b" => :catalina
    sha256 "84f3312865cd188bc4bca33340d8f050ae4cd6bafb5af9ba078b14084cefedee" => :mojave
    sha256 "f4ef9cd5a3d081ee3edcc38fdb762e6cbc3c0a8cf1b19cd1d5ca873ac649b7cc" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/VirgilSecurity/virgil-cli"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", "virgil"
      bin.install "virgil"
    end
  end

  test do
    result = shell_output "#{bin}/virgil pure keygen"
    assert_match /SK.1./, result
  end
end
