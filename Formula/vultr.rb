require "language/go"

class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/1.11.0.tar.gz"
  sha256 "a6af3e4e88cf45f2a6ccfac5530bfebbd1c347c18568932c51c0c28c82e953e8"
  revision 1
  head "https://github.com/JamesClonk/vultr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd6a3b9b8cc9f458a4b8706d9d7891a69cfaf2ca116f14d90646d9e9d8453ec2" => :sierra
    sha256 "f0fa084d8658a551d7a00f02b7f8ede27061315cc5e1115aff00006642e769ac" => :el_capitan
    sha256 "140ff31afcbadc6d9f941030ab4a68e9c3279b9e16332f489961518405b75222" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on "gdm" => :build

  go_resource "github.com/jawher/mow.cli" do
    url "https://github.com/jawher/mow.cli.git",
        :revision => "0de3d3b4ed00f261460d12ecde4efa90fbfcd8ed"
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
