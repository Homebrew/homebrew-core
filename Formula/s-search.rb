require "language/go"

class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.5.2.tar.gz"
  sha256 "e4e224bffec720d718ac066a329097b5fd05d3c2c1a3c5b071d710abc7104220"
  head "https://github.com/zquestz/s.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc7219a4610ae994e217543289935fd3d00b2f0038e9ef318aed1e1e9c443952" => :el_capitan
    sha256 "28c0eddd56ddfe99c3c30e4fea6c1a288f595b84158aa6f85f4f8a65b3f05e14" => :yosemite
    sha256 "46cc653b0036738fa31b89498af1673052f24a255b5363ed611183da5c2fbb59" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/NYTimes/gziphandler" do
    url "https://github.com/NYTimes/gziphandler.git",
    :revision => "63027b26b87e2ae2ce3810393d4b81021cfd3a35"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
    :revision => "756f7b183b7ab78acdbbee5c7f392838ed459dda"
  end

  go_resource "github.com/spf13/cobra" do
    url "https://github.com/spf13/cobra.git",
    :revision => "6a8bd97bdb1fc0d08a83459940498ea49d3e8c93"
  end

  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
    :revision => "367864438f1b1a3c7db4da06a2f55b144e6784e0"
  end

  go_resource "github.com/zquestz/go-ucl" do
    url "https://github.com/zquestz/go-ucl.git",
    :revision => "ec59c7af0062f62671cdc1e974aa857771f105d2"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
    :revision => "4440cd4f4c2ea31e1872e00de675a86d0c19006c"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/zquestz").mkpath
    ln_s buildpath, "src/github.com/zquestz/s"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"s"
  end

  test do
    output = shell_output("#{bin}/s -p bing -b echo homebrew")
    assert_equal "https://www.bing.com/search?q=homebrew", output.chomp
  end
end
