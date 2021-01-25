class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.2.1.tar.gz"
  sha256 "a1470285e04b69ee7a2bb3948b64e1da9cabe59658997b50aac7c64465f330bd"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f93007ab5ea824a026a39f2b7a213a960a5972ba220d1d90f370db29cf657a24" => :big_sur
    sha256 "fa4eb8545b97614e675559c13834cc99613dc06b2c44978cb6c00e5229356825" => :arm64_big_sur
    sha256 "5f951da40da37160371fbd3c6a6ed910de2b9f44145ae947e6669b941224c73c" => :catalina
    sha256 "2fd94d5805fa4f12a19fd99b2496778f814b61ef1cdbd6acff04a22fc9afd256" => :mojave
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
