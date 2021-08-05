class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.3.1.tar.gz"
  sha256 "c3acf5503e42f481ff3ec133007f85438a2df378981446456937a56dde758a52"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a332c887ceb8c7f3a72cd8397f664fb4c5a32058a0000d78b1c1956c15961d7a"
    sha256 cellar: :any_skip_relocation, big_sur:       "6d6d70ecb1dc08bdb1385633474acaac8ebcd0e4117373c3b43abf1a8e9af0cb"
    sha256 cellar: :any_skip_relocation, catalina:      "0ed44ac85127c787062ab7c0efe07976edbb973e707b42498810e63bba853dd9"
    sha256 cellar: :any_skip_relocation, mojave:        "5100a78c91b9eafb3c26123b8aa4dec442b3ea2af000c94ee6da23170f645ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ee538b65a2f9eb5761e4b7606ddc24ec32e2c3164665cd43a38d620a5b63f16"
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
