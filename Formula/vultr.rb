require "language/go"

class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/1.12.0.tar.gz"
  sha256 "c95d90dc7972bd4f41d665c4632a428d3f1d0fb68b34665a3bf120ce3d69f5f7"
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
