require "language/go"

class Srclib < Formula
  desc "Polyglot code analysis library, built for hackability"
  homepage "https://srclib.org"
  url "https://github.com/sourcegraph/srclib/archive/v0.2.5.tar.gz"
  sha256 "f410dc87edb44bf10ce8ebd22d0b3c20b9a48fd3186ae38227380be04580574a"
  head "https://github.com/sourcegraph/srclib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9139e4e75f80bec18ffe9c09404fdfc070c82060efae6db21fd51e8098c73ee7" => :sierra
    sha256 "ec633330429e97a2cb82dea7177937c304433c857e97d2b7c6e0ab408f5d3912" => :el_capitan
    sha256 "adfdc037e211208e22d08f422c628bd709a7896a35a6177f7c2b303135e709ae" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/alecthomas/binary" do
    url "https://github.com/alecthomas/binary.git",
        :revision => "8b2a3aa0ba1c1e495274f8e63f57dc7f76107753"
  end

  go_resource "github.com/alecthomas/unsafeslice" do
    url "https://github.com/alecthomas/unsafeslice.git",
        :revision => "763102eafe597ba6cc5c6e847006e3e9851c2786"
  end

  go_resource "github.com/alexsaveliev/go-colorable-wrapper" do
    url "https://github.com/alexsaveliev/go-colorable-wrapper.git",
        :revision => "99a0af7e4f8cb31ba0cbecd070648a1f3f7c4c33"
  end

  go_resource "github.com/gogo/protobuf" do
    url "https://github.com/gogo/protobuf.git",
        :revision => "8d70fb3182befc465c4a1eac8ad4d38ff49778e2"
  end

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
        :revision => "8ee79997227bf9b34611aee7946ae64735e6fd93"
  end

  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
        :revision => "c2c54e542fb797ad986b31721e1baedf214ca413"
  end

  go_resource "github.com/kr/binarydist" do
    url "https://github.com/kr/binarydist.git",
        :revision => "3035450ff8b987ec4373f65c40767f096b35f2d2"
  end

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git",
        :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "d228849504861217f796da67fae4f6e347643f15"
  end

  go_resource "github.com/neelance/parallel" do
    url "https://github.com/neelance/parallel.git",
        :revision => "4de9ce63d14c18517a79efe69e10e99d32c850c3"
  end

  go_resource "github.com/rogpeppe/rog-go" do
    url "https://github.com/rogpeppe/rog-go.git",
        :revision => "f57ad5e24ab7813942c045f86eda1066eb969e98"
  end

  go_resource "github.com/smartystreets/mafsa" do
    url "https://github.com/smartystreets/mafsa.git",
        :revision => "1575156d598714bb1c41713191eefb7f5ccf3e8b"
  end

  go_resource "github.com/sqs/fileset" do
    url "https://github.com/sqs/fileset.git",
        :revision => "012a6d31cbc4d10f3148918e0a37cd333db58a34"
  end

  go_resource "github.com/sqs/go-selfupdate" do
    url "https://github.com/sqs/go-selfupdate.git",
        :revision => "d36f0a97c909dccd193274709266ff9b68a003db"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "4971afdc2f162e82d185353533d3cf16188a9f4e"
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
        :revision => "167995c67fa45f3a7fc8dab62bb872212e397c11"
  end

  go_resource "google.golang.org/grpc" do
    url "https://github.com/grpc/grpc-go.git",
        :revision => "eca2ad68af4d7bf894ada6bd263133f069a441d5"
  end

  go_resource "gopkg.in/inconshreveable/go-update.v0" do
    url "https://gopkg.in/inconshreveable/go-update.v0.git",
        :revision => "d8b0b1d421aa1cbf392c05869f8abbc669bb7066"
  end

  go_resource "sourcegraph.com/sourcegraph/go-flags" do
    url "https://github.com/sourcegraph/go-flags.git",
        :revision => "dace7e122742808bf6016bdc6510649d84f2a31e"
  end

  go_resource "sourcegraph.com/sourcegraph/makex" do
    url "https://github.com/sourcegraph/makex.git",
        :revision => "3f62e8d29c0ff8c517a78ced8318b03110c3f532"
  end

  go_resource "sourcegraph.com/sourcegraph/rwvfs" do
    url "https://github.com/sourcegraph/rwvfs.git",
        :revision => "d433415e8d1212f40c9a508851f08ba91e5996da"
  end

  go_resource "sourcegraph.com/sourcegraph/srclib" do
    url "https://github.com/sourcegraph/srclib.git",
        :revision => "28ba5745ba2ee2cbe539a8d696cab64556db542f"
  end

  go_resource "sourcegraph.com/sqs/pbtypes" do
    url "https://github.com/sqs/pbtypes.git",
        :revision => "4d1b9dc7ffc3f7b555de9b02055fa616f0ebcd18"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/sourcegraph.com/sourcegraph"
    ln_sf buildpath, buildpath/"src/sourcegraph.com/sourcegraph/srclib"
    Language::Go.stage_deps resources, buildpath/"src"

    cd "cmd/srclib" do
      system "go", "build", "-o", "srclib"
      bin.install "srclib"
    end
  end

  test do
    system "#{bin}/srclib", "info"
  end
end
