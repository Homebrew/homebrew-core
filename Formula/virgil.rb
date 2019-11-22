class Virgil < Formula
  desc "CLI tool to manage your Virgil account and applications"
  homepage "https://github.com/VirgilSecurity/virgil-cli"
  url "https://github.com/VirgilSecurity/virgil-cli.git",
     :tag      => "v5.1.6",
     :revision => "41305d0a181da9915e361fc0dd6c6cee8161bbe3"
  head "https://github.com/VirgilSecurity/virgil-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d031ab150d2e143ce3e655ca8adda5fcff86fe784fb650535f5ffeb56ebb640" => :catalina
    sha256 "81ce76c5dabd29e3d5d06f65359e08caa11dbbf06191e79efd23315e0e90c9d5" => :mojave
    sha256 "152e84ec92c664b11d005ef2d4a8101546c70d2394f571ef63931f39efdaf38e" => :high_sierra
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
