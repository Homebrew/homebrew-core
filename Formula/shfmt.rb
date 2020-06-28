class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.1.2.tar.gz"
  sha256 "133fcdb4645ee0c2893319b1ce5b83c88b8576c1e3936b1fa14b967df1501ee5"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9df4c93f70e9b4f188e01708581df840f307892b8108d03aa112c079a4a8574" => :catalina
    sha256 "8db6d076e017a6457a996f83c50a50fc12e83ce9a203a39c9288418230142873" => :mojave
    sha256 "75ba43415d9d77fe4dfd091bd8888f632ee94fcedf32e5141855cafefdd8333b" => :high_sierra
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
