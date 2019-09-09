class Virgil < Formula
  desc "CLI tool to manage your Virgil account and applications"
  homepage "https://github.com/VirgilSecurity/virgil-cli"
  url "https://github.com/VirgilSecurity/virgil-cli.git",
     :tag      => "v5.1.1",
     :revision => "b914b8a6bd707f220a83656e8c8e4c3995300417"
  head "https://github.com/VirgilSecurity/virgil-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "55a17c873e46a627d1ad226beaf1e58470a7e34dfc726eb6413be426cbc41c72" => :mojave
    sha256 "96d75814d4c565dcb06917309e8eda6bfdc63a352a1b4abc5906fc600be44e2e" => :high_sierra
    sha256 "e1b21946eaadf0c7a9fb1bf222fa8c24ac078052d29ed3c41215735ae367c80f" => :sierra
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
