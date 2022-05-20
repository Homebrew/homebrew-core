class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.5.0.tar.gz"
  sha256 "d5a050d19df33b5c40939f49859ef118b4f9c0476f5b1172db2aaa7979c97cee"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7eb293e2f78bdd8de97bb7dd497cf5c7859fc4dc5d16a39449abde7c4a95ba57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bb226e3bd76e581a782070803404d06e2d55ca3543b13b2fab7855beb6515e4"
    sha256 cellar: :any_skip_relocation, monterey:       "4cdfb91026a3008080edf964a8a5e13b4bb019b4819d9d2aed75b0553e770303"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a867a533ad223d7b5930384f733fe025fb0f28c8ac9204f18d68482495a5038"
    sha256 cellar: :any_skip_relocation, catalina:       "8944dc0b8a53131fbd2ec13c6280a9296eac52bf5ad47dd8c70b1cbd7cada21b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d71cf85ecae70836358d19eb275f0dfc897f16b6a5e8f6587b1c0642ad99cc17"
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
