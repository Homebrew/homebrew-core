require "language/go"

class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.5.3.tar.gz"
  sha256 "e2cf0398899becc92df4d1a153c7fd523e1f50c7d708f575ab0e69e51b046903"
  head "https://github.com/zquestz/s.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c304a280b03d2108d2a584d0ddba3d3f268f4ca222b838de75a5dfc19614d001" => :el_capitan
    sha256 "9ced2df29cf3b081387e544f5826c75ce95af117db9e744244eb96b0212997f3" => :yosemite
    sha256 "c448b231dc092b5ae65697424aceb4422b52b3e103b95b1477b09a96f4cdb85d" => :mavericks
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
    :revision => "ce78b075c2fbd48520f4995b173eb9fe18b56ef3"
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
