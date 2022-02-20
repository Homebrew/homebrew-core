class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.4.3.tar.gz"
  sha256 "8bfb7cc980164bfeeedd2f8866e6af23c31a4720965601a5b777a14783dfe031"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a9fb0705340684312ac9c92fc448743de717587440518267d4adac0ad83655c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37adbd3e95760b7c729d045882e5b2db2528037ca8980c4216cd8176cd2aac3d"
    sha256 cellar: :any_skip_relocation, monterey:       "4e1f4404a999dfaad2a7304210dddef98a9871593a7ab69362fe99e457400ba3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3847119018b86770f101e86dfc4ebfd73fd43a77a5dceb003d0d2aa6ade2014f"
    sha256 cellar: :any_skip_relocation, catalina:       "10d8a6351ec8f7aba3965e153e73bbd099570047de3f134f8b81824f95945a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a25494a19bccb9ab403ce35141dd846ef1e0b3fa66ef517a399a738ef21a6830"
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
