require "language/go"

class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.5.13.tar.gz"
  sha256 "aac903c372324b1e57b0c61ba28d2c631ed81cb0e04f085661f2b6c0763ec818"
  head "https://github.com/zquestz/s.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ce3221c790404942e5f5777ecc454e6f2bd97d8e4af50ed408a803ffc797c62" => :mojave
    sha256 "43540301fcb089e70db3731d4788289b1078c0d03223d797fe9b9e90bf3631e3" => :high_sierra
    sha256 "734bd178c5b32134ed870e8f5fae9684139f48408ab16389a1ffcd81923707a6" => :sierra
  end

  depends_on "go" => :build

  go_resource "github.com/FiloSottile/gvt" do
    url "https://github.com/FiloSottile/gvt.git",
        :revision => "50d83ea21cb0405e81efd284951e111b3a68d701"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    cd("src/github.com/FiloSottile/gvt") { system "go", "install" }
    (buildpath/"src/github.com/zquestz").mkpath
    ln_s buildpath, "src/github.com/zquestz/s"
    system buildpath/"bin/gvt", "restore"
    system "go", "build", "-o", bin/"s"
  end

  test do
    output = shell_output("#{bin}/s -p bing -b echo homebrew")
    assert_equal "https://www.bing.com/search?q=homebrew", output.chomp
  end
end
