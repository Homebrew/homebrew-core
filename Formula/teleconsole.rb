require "language/go"

class Teleconsole < Formula
  desc "Free service to share your terminal session with people you trust"
  homepage "https://www.teleconsole.com"
  url "https://github.com/gravitational/teleconsole/archive/0.3.1.tar.gz"
  sha256 "663307a1dfe4baadf7e1ed9f5b66b1d203bf9696068e9bcd86e535f286e64d59"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f51cf4866e3e7955dadc31e6a73c30fd99566c110674394d34dfdefc042453c" => :mojave
    sha256 "a00b04aeb2e57c8ae3cca20632033bb2a60e1c3ec242497bee4a14240e5276a5" => :high_sierra
    sha256 "77f2ea18e72c3662cdc3a9b204752b4d18ee65df2a4d9b47d53b31a7440a5109" => :sierra
    sha256 "d7b7e6dd7c164f7145532f14fae09909651c4f997e75c8b8b2f5b98b9512a117" => :el_capitan
    sha256 "7e2997cfe314a0b08332bfc6c4611707f8c97aa80ba92bc74a6ce3d2abc9c159" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git",
        :revision => "d26492970760ca5d33129d2d799e34be5c4782eb"
  end

  go_resource "github.com/gravitational/trace" do
    url "https://github.com/gravitational/trace.git",
        :revision => "6e153c7add15eb07e311f892779fb294373c4cfa"
  end

  go_resource "github.com/gravitational/teleport" do
    url "https://github.com/gravitational/teleport.git",
        :revision => "002b640a16f097e2f834b4ae33c9edfb81d5798c"
  end

  go_resource "github.com/jonboulle/clockwork" do
    url "https://github.com/jonboulle/clockwork.git",
        :revision => "bcac9884e7502bb2b474c0339d889cb981a2f27f"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "9477e0b78b9ac3d0b03822fd95422e2fe07627cd"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "55a3084c9119aeb9ba2437d595b0a7e9cb635da9"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "bf82308e8c8546dc2b945157173eb8a959ae9505"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "d228849504861217f796da67fae4f6e347643f15"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "66b8e73f3f5cda9f96b69efd03dd3d7fc4a5cdb8"
  end

  patch do
    url "https://github.com/gravitational/teleconsole/pull/8.patch?full_index=1"
    sha256 "54f551f939c82c482a4aa6df5dbf5077943cf39f2b1d5265a0747c9cc5606e24"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/gravitational"
    ln_s buildpath, buildpath/"src/github.com/gravitational/teleconsole"
    Language::Go.stage_deps resources, buildpath/"src"
    system "make", "OUT=#{bin}/teleconsole"
  end

  test do
    system "#{bin}/teleconsole", "help"
  end
end
