class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.6.0.tar.gz"
  sha256 "4fe5a7b0aab5fba437696b68c5424e49ba9f793de2f534647e1d814108ebad23"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7892f629d0c059bda5446d9a5c334ddaddc61ef7f5fbbb8c3dc9dea038ff4cda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e32357de6b64064d14ddec0dc909b252403f139e2da5473a48c60283315805ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1918c1c4328c275673c428356a01a7615405944d5599a246884022942148be4b"
    sha256 cellar: :any_skip_relocation, ventura:        "2fd051b6ee6662769993d361a510a5b5e7e42c6d71e529c19d724fc70e58af64"
    sha256 cellar: :any_skip_relocation, monterey:       "f46218b6f7a26e2d9d54a0e23f2092e387b2c701191c4febe09678086950c430"
    sha256 cellar: :any_skip_relocation, big_sur:        "c602bf7d13a7d97a1c955072c7c6fe93735561788ebd21cd83b9b27dd864c8af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6a63b4e3c3daa166d0f95762c72f2e38fdf426500c82f2166e3af22cf490a11"
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
