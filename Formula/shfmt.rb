class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.2.0.tar.gz"
  sha256 "6755f587fcb6f037f819b96a322b0273d0ab6ecb5911c005b9aae74292c4a819"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "42bd98e64ae352448f09fdc2b56a71e36e3659e382338447e94d20f4d7befcff" => :catalina
    sha256 "d58c28c678be4be515c4a22e99338f7b1120a9f9d2eb004b6d7863a284ad5295" => :mojave
    sha256 "127c0adf737c2de8d0a23850249b7cbc22fe5f864434c331ed521d4f00f3f3f7" => :high_sierra
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
