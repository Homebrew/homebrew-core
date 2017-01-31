require "language/go"

class Qpm < Formula
  desc "Package manager for Qt applications"
  homepage "https://www.qpm.io"
  url "https://github.com/Cutehacks/qpm/archive/v0.10.0.tar.gz"
  sha256 "2c56aa81e46fb144ff25b14a26476862462510e38cf1265b24c38e3ac4636ee5"

  bottle do
    rebuild 1
    sha256 "688340ba4e5090f53314dc899ea72be1411c47e70cbc7c304ef7f086104f5441" => :sierra
    sha256 "1ffb2fbc1859ead75a7e128540f0ba049d712bc1012fdee153cd44a250411433" => :el_capitan
    sha256 "2504007ec81ac8e1db4c473a3cdbadf677ff921f46b38ae3bd35e781ddd7c341" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
        :revision => "d3d78384b82d449651d2435ed329d70f7c48aa56"
  end

  go_resource "github.com/howeyc/gopass" do
    url "https://github.com/howeyc/gopass.git",
        :revision => "10b54de414cc9693221d5ff2ae14fd2fbf1b0ac1"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "575fdbe86e5dd89229707ebec0575ce7d088a4a6"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "042ba42fa6633b34205efc66ba5719cd3afd8d38"
  end

  go_resource "google.golang.org/grpc" do
    url "https://github.com/grpc/grpc-go.git",
        :revision => "3490323066222fe765ef7903b53a48cbc876906d"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", "bin/qpm", "qpm.io/qpm"
    bin.install "bin/qpm"
  end

  test do
    system bin/"qpm", "install", "io.qpm.example"
    assert File.exist?(testpath/"qpm.json")
  end
end
