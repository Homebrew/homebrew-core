class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.2.2.tar.gz"
  sha256 "e990aed5bb167f5cfc6790243ec3cc5e18508a64e8c9609ed5015634ba053b16"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b4371ba5acedef0249229c4355aaad90b9fd2ce78c1664deb323edf5d3a30c22"
    sha256 cellar: :any_skip_relocation, big_sur:       "ac89ac489e6613322caae173fd5d422032a7c967ce575a89a0a719bd4161aafb"
    sha256 cellar: :any_skip_relocation, catalina:      "2a19f4a4e8c89a64071ef90248848199bd04b253c95c1d7f365e627068f69acc"
    sha256 cellar: :any_skip_relocation, mojave:        "8ba9f2635036f292ce79b2735421f822dbbbff454d2dd1274f29d48133951a97"
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
