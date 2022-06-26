class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.5.1.tar.gz"
  sha256 "f15ca9952ef6dc4c1051550152768a99dde0d3f72269d0510f75522a492270cf"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "633116b598a60ad576a79753208e13388f6a2460139c8aca44e5a25befdb017c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b0653c0a44f7db5e78c5c6d67de534a52c4f588fb65e3acbb8211d06b871bd9"
    sha256 cellar: :any_skip_relocation, monterey:       "e7168603f81cf1357c2460c5c476fa66bf5421183d4dedeafe9cf38550fe8855"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e0683566d83cceecd4d02596e3c899a640918ff067b6e15e10f8aee424f1759"
    sha256 cellar: :any_skip_relocation, catalina:       "4fabb118ba0da244f2b0ffe280b28e343712fac23e738ddf1db29fad68526d73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faa60f70812132e10f94477676499a1e2bacb0d06fbe437e8480a997695c2203"
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
