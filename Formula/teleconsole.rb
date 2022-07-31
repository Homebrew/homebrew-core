require "language/go"

class Teleconsole < Formula
  desc "Free service to share your terminal session with people you trust"
  homepage "https://www.teleconsole.com"
  url "https://github.com/gravitational/teleconsole/archive/0.4.0.tar.gz"
  sha256 "ba0a231c5501995e2b948c387360eb84e3a44fe2af6540b6439fc58637b0efa4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "d027484ac3f03fd9cf35f3a90bc241c04709f29e499d29bbd1c4d5f636bc1876"
    sha256 cellar: :any_skip_relocation, big_sur:      "a7d96f387532f40298ff90dc062994e933fc009500279421a16182b063f39446"
    sha256 cellar: :any_skip_relocation, catalina:     "fd114a850d3e9eb653e6ed08f53224bd81219c7bcfbd2459440b68a0e96711dc"
    sha256 cellar: :any_skip_relocation, mojave:       "4a5a767d1097e9e8580e3d3ad77d01b8b840ef622092983d713333ed90d2db0d"
    sha256 cellar: :any_skip_relocation, high_sierra:  "d53e81606f1e85b59bd3ee364e006989187f5cce884b33fb77b104b931a7e3c5"
    sha256 cellar: :any_skip_relocation, sierra:       "c74fa8ac5e92c39a3f0d869b9e8bd44d32ab67ed0748b5548a0700287dfbe817"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c143c1ce6d0119de540cd748544c68d55ea414e610c58cf6c02cb3cd9717c307"
  end

  disable! date: "2022-07-31", because: :repo_archived

  depends_on "go" => :build

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git",
        revision: "d26492970760ca5d33129d2d799e34be5c4782eb"
  end

  go_resource "github.com/gravitational/trace" do
    url "https://github.com/gravitational/trace.git",
        revision: "6e153c7add15eb07e311f892779fb294373c4cfa"
  end

  go_resource "github.com/gravitational/teleport" do
    url "https://github.com/gravitational/teleport.git",
        revision: "2cb40abd8ea8fb2915304ea4888b5b9f3e5bc223"
  end

  go_resource "github.com/jonboulle/clockwork" do
    url "https://github.com/jonboulle/clockwork.git",
        revision: "bcac9884e7502bb2b474c0339d889cb981a2f27f"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        revision: "9477e0b78b9ac3d0b03822fd95422e2fe07627cd"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        revision: "55a3084c9119aeb9ba2437d595b0a7e9cb635da9"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        revision: "bf82308e8c8546dc2b945157173eb8a959ae9505"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        revision: "d228849504861217f796da67fae4f6e347643f15"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        revision: "66b8e73f3f5cda9f96b69efd03dd3d7fc4a5cdb8"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    mkdir_p buildpath/"src/github.com/gravitational"
    ln_s buildpath, buildpath/"src/github.com/gravitational/teleconsole"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"teleconsole"
  end

  test do
    system "#{bin}/teleconsole", "help"
  end
end
