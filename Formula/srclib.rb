class Srclib < Formula
  desc "Polyglot code analysis library, built for hackability"
  homepage "https://srclib.org"
  url "https://github.com/sourcegraph/srclib/archive/v0.2.5.tar.gz"
  sha256 "f410dc87edb44bf10ce8ebd22d0b3c20b9a48fd3186ae38227380be04580574a"
  head "https://github.com/sourcegraph/srclib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c70f80acb0d5ff85add633b002e79a235ec8645ac700a9dc12f422ad3d80464c" => :high_sierra
    sha256 "9139e4e75f80bec18ffe9c09404fdfc070c82060efae6db21fd51e8098c73ee7" => :sierra
    sha256 "ec633330429e97a2cb82dea7177937c304433c857e97d2b7c6e0ab408f5d3912" => :el_capitan
    sha256 "adfdc037e211208e22d08f422c628bd709a7896a35a6177f7c2b303135e709ae" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    (buildpath/"src/sourcegraph.com/sourcegraph/srclib").install buildpath.children

    cd "src/sourcegraph.com/sourcegraph/srclib" do
      system "godep", "restore"
      system "go", "build", "-o", bin/"srclib", "./cmd/srclib"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/srclib", "info"
  end
end
