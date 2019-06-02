class Virgil < Formula
  desc "CLI tool to manage your Virgil account and applications"
  homepage "https://github.com/VirgilSecurity/virgil-cli"
  url "https://github.com/VirgilSecurity/virgil-cli.git",
     :tag      => "v5.0.1",
     :revision => "03ddee65e9cecbdd7ef55b1285c0ca70758d6d40"
  head "https://github.com/VirgilSecurity/virgil-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "93aafd187b3594c56920b5f59df7d88b6de8d10bf5302618690370e898e801a9" => :mojave
    sha256 "69c30a792aedf2422d32a0d4fc0ff272fee46e8a0277eaf8865c3d47a50f62b2" => :high_sierra
    sha256 "5b71177f0535c11b793e7700660779da6fda6a5fdbd5165ddff57efe7eac9aa7" => :sierra
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
