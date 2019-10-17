class Virgil < Formula
  desc "CLI tool to manage your Virgil account and applications"
  homepage "https://github.com/VirgilSecurity/virgil-cli"
  url "https://github.com/VirgilSecurity/virgil-cli.git",
     :tag      => "v5.1.4",
     :revision => "b73fa53e434d006cbf0a5b92ccb84f8cd88b62da"
  head "https://github.com/VirgilSecurity/virgil-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "704d8a3b991939d89255e5115b794b4bdda7e6aade7488c9afcceb54bf6510af" => :catalina
    sha256 "8ebfd8eb444498ae8cf640a6dc9b959fa2ee69f189a392d3892599872e141dd2" => :mojave
    sha256 "6b1bbcd9a4b50bc15f89e70de8bb45a71abcceadcf8c1eed0bd0d3664029f694" => :high_sierra
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
