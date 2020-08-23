class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/v2.0.2.tar.gz"
  sha256 "bb60e6f82a2900fdcf025362a29efed64806e58a3e2e8251e4e5f5e6f076b763"
  license "MIT"
  head "https://github.com/JamesClonk/vultr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a73bd34611c56aefe57e5491191ae90109f779f49ecacee332c0e55745e84c89" => :catalina
    sha256 "bce926c779ee605e3f36d9135dfd08bb898f62440cf04e5bcd991afd517931f2" => :mojave
    sha256 "5f6278c15bd1487cbdee6b871057074b1a548a9dfba7a98b202d3ccbc12966c2" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/JamesClonk").mkpath
    ln_s buildpath, buildpath/"src/github.com/JamesClonk/vultr"
    system "go", "build", "-o", bin/"vultr"
  end

  test do
    system bin/"vultr", "version"
  end
end
