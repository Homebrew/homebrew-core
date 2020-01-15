class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.0.1.tar.gz"
  sha256 "4cca3d8a40e5132a4764a3bf7bcf335288ebff8a4a74e130f9359605e6f07544"
  revision 1
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6358293ae23a216f4349ac0ab191bf9b17e9205a979cc0934c839406066194ce" => :catalina
    sha256 "d05ca216d6a5b95ad55eaca1e5faf4c346ae9b9f9fc82eb644dfdc3b684ed646" => :mojave
    sha256 "4b32111c7f53b4f21cc971b866f218b40ba87cb3606c5fe418eabb2a4dc886d4" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    (buildpath/"src/mvdan.cc").mkpath
    ln_sf buildpath, buildpath/"src/mvdan.cc/sh"
    system "go", "build", "-a", "-tags", "production brew", "-ldflags", "-w -s -extldflags '-static'", "-o", "#{bin}/shfmt", "./cmd/shfmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt  --version")

    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end
