require "language/go"

class Qpm < Formula
  desc "Package manager for Qt applications"
  homepage "https://www.qpm.io"
  url "https://github.com/Cutehacks/qpm/archive/v0.10.0.tar.gz"
  sha256 "2c56aa81e46fb144ff25b14a26476862462510e38cf1265b24c38e3ac4636ee5"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "e10b8209ffb5e0d36025c9aea3c53379628d4631d6bdaa46d0566625f8dede6d" => :high_sierra
    sha256 "6dab4a36e19b1cd7a6a898d516b0fc59289798213b97a2c06130b63f69243eaa" => :sierra
    sha256 "f2a77569109ea443de6fc94788906b1862ee183f3ecd6c065f7b05351f777eb6" => :el_capitan
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
