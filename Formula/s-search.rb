require "language/go"

class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.5.14.tar.gz"
  sha256 "c32eedf6a4080cbe221c902cf7f63b1668b3927edfc448d963d69ed66c8ec2fb"
  head "https://github.com/zquestz/s.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd7352e1c4092774fdd4cbff61bd107e6447ea00e96ec94431dcbc1be7bbade5" => :catalina
    sha256 "04281fb66e28cf23c3ea1cd23ec6286432191fde31ac8c7b6c9c13bc6b365b0a" => :mojave
    sha256 "4a0c5595943e8b7b4892ff3caf4d03b29533405a411268a77e0a51272a3d7823" => :high_sierra
    sha256 "b9d547b1bcc45516396ed8398b624ac83a1c4ade7bf13f130b1b063b9aec1590" => :sierra
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
