class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.1.0.tar.gz"
  sha256 "b05b0c0fdd7dd202c1be75920d501b3735a065322f09c280db0949631e7e0d92"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f5428c697aaa1c8f6c9ef1962a12b516746aea50718e7e59bb8cf8c5b3f6f0c" => :catalina
    sha256 "833bc26b402baccb14b51ab208aa13edb4838d59ef3f490fe6b11e3e9ea42253" => :mojave
    sha256 "813f4f3b102bbedc95eef92c952b663be6c572edfb5248da453cba5f33e66aba" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    (buildpath/"src/mvdan.cc").mkpath
    ln_sf buildpath, buildpath/"src/mvdan.cc/sh"
    system "go", "build", "-a", "-tags", "production brew", "-ldflags",
                          "-w -s -extldflags '-static' -X main.version=#{version}",
                          "-o", "#{bin}/shfmt", "./cmd/shfmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt  --version")

    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end
