require "language/go"

class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.5.3.tar.gz"
  sha256 "e2cf0398899becc92df4d1a153c7fd523e1f50c7d708f575ab0e69e51b046903"
  head "https://github.com/zquestz/s.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dad8a7ea2f07d49a9ba643a1614d4d4921c623671134a6f4b72c5efb1d5dcf5e" => :el_capitan
    sha256 "743d1d642507e1801f14a0e671602268964c67dc4828e51d64a3cae1abb8f1f4" => :yosemite
    sha256 "8b37ab0bcbd4c8638cc117ce31d3d57410432e6143cf5749d921b45871b1bd26" => :mavericks
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
