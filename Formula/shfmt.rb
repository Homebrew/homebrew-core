class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.3.0.tar.gz"
  sha256 "9bcdbbfd2f6afc4e885838683396483edcd87ef7eb80faa7def6ff0a10e3be4a"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "37df770767ede3c8bb6ff43006e029250c5c78038aba6f234b237052a1cd1722"
    sha256 cellar: :any_skip_relocation, big_sur:       "789f53db9def4a6002efc5f37d0919a5c1e0deb104fdb29583d13392e36e5824"
    sha256 cellar: :any_skip_relocation, catalina:      "ba4a63cdc920a07874901d86abeccbcbb3d4bcb834ed550a02732c0ed878a05d"
    sha256 cellar: :any_skip_relocation, mojave:        "cbf100be8e2deb0e57781495075d4527e251ecc9972bc2e8c6ecd39237f89988"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    (buildpath/"src/mvdan.cc").mkpath
    ln_sf buildpath, buildpath/"src/mvdan.cc/sh"
    system "go", "build", "-a", "-tags", "production brew", "-ldflags",
                          "-w -s -extldflags '-static' -X main.version=#{version}",
                          "-o", "#{bin}/shfmt", "./cmd/shfmt"
    man1.mkpath
    system "scdoc < ./cmd/shfmt/shfmt.1.scd > #{man1}/shfmt.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt  --version")

    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end
