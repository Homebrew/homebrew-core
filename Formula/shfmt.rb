class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.2.1.tar.gz"
  sha256 "a1470285e04b69ee7a2bb3948b64e1da9cabe59658997b50aac7c64465f330bd"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b7d32f7c03b834d095c85962159bd9406a053309a1e0ab471afae3d713f6c2f" => :big_sur
    sha256 "d92a8a5a5a49abd58ea5efadd750fe203985093af4c7575be389da02d50c84ac" => :catalina
    sha256 "53262774401bb3671d96d12e2a279cc6aee11980931f37e8b74c459e03f9191e" => :mojave
    sha256 "6bffd631df5ad9173c9037f48c143c57df1f0b3a5c6b778a9ce304dcd29c05a7" => :high_sierra
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
