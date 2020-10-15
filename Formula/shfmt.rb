class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.1.2.tar.gz"
  sha256 "133fcdb4645ee0c2893319b1ce5b83c88b8576c1e3936b1fa14b967df1501ee5"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "42bd98e64ae352448f09fdc2b56a71e36e3659e382338447e94d20f4d7befcff" => :catalina
    sha256 "d58c28c678be4be515c4a22e99338f7b1120a9f9d2eb004b6d7863a284ad5295" => :mojave
    sha256 "127c0adf737c2de8d0a23850249b7cbc22fe5f864434c331ed521d4f00f3f3f7" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    (buildpath/"src/mvdan.cc").mkpath
    ln_sf buildpath, buildpath/"src/mvdan.cc/sh"
    system "go", "build", "-a", "-tags", "production brew", "-ldflags",
                          "-w -s -extldflags '-static' -X main.version=#{version}",
                          "-o", "#{bin}/shfmt", "./cmd/shfmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt  --version")

    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end
