require "language/go"

class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/v1.10.tar.gz"
  sha256 "d794d38f1c0693601604d420b4d50695e267abb5f41aa21592ac249208092912"
  head "https://github.com/JamesClonk/vultr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d54c0cdfe2292d34471ff9ec222d2886c5307d5b06e7cd0a3059260dcdce8f1b" => :sierra
    sha256 "2c34b24081e7db7b67c07981cfa7f3c2dc205950fee0f65aaee15609e97ed74c" => :el_capitan
    sha256 "bf0370c3b3dc0d68030ee43b83bf4c7bc5e5fe33f0912c64d0312436d5428bc2" => :yosemite
    sha256 "d3ecc735a5188d2861eeb8a630cb0323a1e0b5a32bb38d23446101bfe4e3a244" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on "gdm" => :build

  go_resource "github.com/jawher/mow.cli" do
    url "https://github.com/jawher/mow.cli.git",
        :revision => "660b9261e2c80bb92e5a0eaa581596084656140e"
  end

  go_resource "github.com/juju/ratelimit" do
    url "https://github.com/juju/ratelimit.git",
        :revision => "77ed1c8a01217656d2080ad51981f6e99adaa177"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/JamesClonk").mkpath
    ln_s buildpath, buildpath/"src/github.com/JamesClonk/vultr"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"vultr"
  end

  test do
    system bin/"vultr", "version"
  end
end
