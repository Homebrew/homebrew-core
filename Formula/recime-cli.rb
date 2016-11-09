
require "language/go"

class RecimeCli < Formula
  desc "Recime command-line tool to create and publish bot."
  homepage "https://recime.ai"
  url "https://github.com/Recime/recime-cli/archive/1.0.tar.gz"
  version "1.0.5"
  sha256 "0655a8c84d43c30016f40781cb4043aa1b1167f932e220ddc194c1f22a213acc"
  head "https://github.com/Recime/recime-cli.git"

  depends_on "go" => :build

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
          :revision => "d228849504861217f796da67fae4f6e347643f15"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
          :revision => "66b8e73f3f5cda9f96b69efd03dd3d7fc4a5cdb8"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
          :revision => "bf82308e8c8546dc2b945157173eb8a959ae9505"
  end

  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
          :revision => "5ccb023bc27df288a957c5e994cd44fd19619465"
  end

  go_resource "github.com/spf13/cobra" do
    url "https://github.com/spf13/cobra.git",
          :revision => "6e91dded25d73176bf7f60b40dd7aa1f0bf9be8d"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
          :revision => "9477e0b78b9ac3d0b03822fd95422e2fe07627cd"
  end

  go_resource "github.com/briandowns/spinner" do
    url "https://github.com/briandowns/spinner.git",
          :revision => "f62babe8722a6a3b79201883ce5b70f73b3d46be"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
          :revision => "756f7b183b7ab78acdbbee5c7f392838ed459dda"
  end

  go_resource "gopkg.in/cheggaaa/pb.v1" do
    url "https://github.com/cheggaaa/pb.git",
          :revision => "dd61faab99a777c652bb680e37715fe0cb549856"
  end

  go_resource "github.com/Recime/recime-cli" do
    url "https://github.com/Recime/recime-cli.git",
          :revision => "12568b073bd4e453679b3430df730a8fccdefd18"
  end

  def install
    mkdir_p buildpath/"src/github.com/Recime/recime-cli/"
    ln_sf buildpath, buildpath/"src/github.com/Recime/recime-cli"

    ENV["GOPATH"] = "#{buildpath}/Godeps/_workspace:#{buildpath}"

    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "recime-cli"
    bin.install "recime-cli"

    # mkdir_p buildpath/"src/github.com/Recime/recime-cli/"
    # ln_sf buildpath, buildpath/"src/github.com/Recime/recime-cli"
    # Language::Go.stage_deps resources, buildpath/"src"
    #
    # system "go", "build", "-o", bin/"recime-cli", "main.go"
  end

  test do
    system bin/"recime-cli", "version"
  end
end
