require "language/go"

class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/1.13.0.tar.gz"
  sha256 "9cb5936ba70f958ab4e53a23da0ef7ea5b11de8ebaf194082c3f758779d49650"
  head "https://github.com/JamesClonk/vultr.git"

  bottle do
    sha256 "3056607438f2129fee2ebe549465643f71df01fb6ae48dde719aeee887c0f8e7" => :sierra
    sha256 "896513d7870dd5d89979afd0e5b74a59c24b0996f185ed37781bf012914bad08" => :el_capitan
    sha256 "dfdfcdb7fe384e5a53a65bbf4bfbaec3a256015ba5da0017f6d7a59de525591b" => :yosemite
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
