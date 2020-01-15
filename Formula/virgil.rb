class Virgil < Formula
  desc "CLI tool to manage your Virgil account and applications"
  homepage "https://github.com/VirgilSecurity/virgil-cli"
  url "https://github.com/VirgilSecurity/virgil-cli.git",
     :tag      => "v5.1.7",
     :revision => "bb86ae1102725e51c85d79bf6babc424be04126d"
  head "https://github.com/VirgilSecurity/virgil-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "67c790483db72b2771c097dce90c5e937f7f5095821afba455b1708c798fedaf" => :catalina
    sha256 "efc28f3cd0fe03f72646c069442a44b3b17e785dfbc2a4c5018f922303f74ed1" => :mojave
    sha256 "ab03a53e7f602341811f1ce6af9ff6b41ccf84ca879f59916fe4f59ff3baca64" => :high_sierra
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
