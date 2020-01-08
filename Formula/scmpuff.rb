class Scmpuff < Formula
  desc "Adds numbered shortcuts for common git commands"
  homepage "https://mroth.github.io/scmpuff/"
  url "https://github.com/mroth/scmpuff/archive/v0.3.0.tar.gz"
  sha256 "239cd269a476f5159a15ef462686878934617b11317fdc786ca304059c0b6a0b"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e191a0aa602fb00cd35bc729261b2b377472b7f8add3d56263680d11ac7183b" => :catalina
    sha256 "304cb27623cc21878468793b8b8375a8a89f4f050cda665d301ecc025690e712" => :mojave
    sha256 "604d1805e793cbf6e0b07e030389a0275ccc98db832ff7564522496302e04985" => :high_sierra
    sha256 "15a2fd8febc6ac36cb3429979fd5c8f88f230ae6276c073a0eedc5ac7e7abf69" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/mroth/scmpuff").install buildpath.children
    cd "src/github.com/mroth/scmpuff" do
      system "go", "build", "-ldflags", "-X main.VERSION=#{version}",
                   "-o", bin/"scmpuff"
      prefix.install_metafiles
    end
  end

  test do
    ENV["e1"] = "abc"
    assert_equal "abc", shell_output("#{bin}/scmpuff expand 1").strip
  end
end
