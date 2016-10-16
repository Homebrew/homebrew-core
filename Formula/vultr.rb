require "language/go"

class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/v1.10.tar.gz"
  sha256 "d794d38f1c0693601604d420b4d50695e267abb5f41aa21592ac249208092912"
  head "https://github.com/JamesClonk/vultr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad760f5ff85df56a96abce0224df04b60983cbbc8a0e0131c76717924e89626f" => :sierra
    sha256 "af34a9509b998f5bc6248ac2368c766d23a2f8e29720d50f569ca1ad4df0a8fa" => :el_capitan
    sha256 "c198a930dc7a08e8dcaac10d991b7f969c91200bd4fd0128888c7ea106db7568" => :yosemite
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
