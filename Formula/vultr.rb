require "language/go"

class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/1.13.0.tar.gz"
  sha256 "9cb5936ba70f958ab4e53a23da0ef7ea5b11de8ebaf194082c3f758779d49650"
  head "https://github.com/JamesClonk/vultr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "05a2602609fd20151e9ab712cd823239e125a5915e5e72f14afa9641a61dc673" => :sierra
    sha256 "0f8ed829f501fad2a7f05e26cfbe7d8b32e3a5df4647021dbe8a9eed16bde438" => :el_capitan
    sha256 "b2bf0d14a74da9e561510fd75694063c8d50ca253b6411940be4ce82a3d2e4ee" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on "gdm" => :build

  go_resource "github.com/jawher/mow.cli" do
    url "https://github.com/jawher/mow.cli.git",
        :revision => "d3ffbc2f98b83e09dc8efd55ecec75eb5fd656ec"
  end

  go_resource "github.com/juju/ratelimit" do
    url "https://github.com/juju/ratelimit.git",
        :revision => "acf38b000a03e4ab89e40f20f1e548f4e6ac7f72"
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
