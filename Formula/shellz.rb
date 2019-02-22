class Shellz < Formula
  desc "Small utility to track and control custom shellz"
  homepage "https://github.com/evilsocket/shellz"
  url "https://github.com/evilsocket/shellz/archive/v1.5.0.tar.gz"
  sha256 "870bcc2d6e4fd20913556f95325bc3e1876f3243ef67295c33e2bcc990126e97"

  bottle do
    cellar :any_skip_relocation
    sha256 "494dc447302a25f84d9a5164f92138ce9ae8b366cf33dd00b71e3e6429e60dd4" => :mojave
    sha256 "e346665aad2c792f1e4f95ee5c35837c86dd43d433da8b475def3174357934e9" => :high_sierra
    sha256 "9dcc0ebb77ba4c79f48158f86584db1b5d00b13ee40bd1d49f3601d1a9d5c2e4" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/evilsocket/shellz").install buildpath.children

    cd "src/github.com/evilsocket/shellz" do
      system "dep", "ensure", "-vendor-only"
      system "make", "build"
      bin.install "shellz"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/shellz -no-banner -no-effects -path #{testpath}", 1)
    assert_match "creating", output
    assert_predicate testpath/"shells", :exist?
  end
end
