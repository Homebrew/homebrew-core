class Srclib < Formula
  desc "Polyglot code analysis library, built for hackability"
  homepage "https://srclib.org"
  url "https://github.com/sourcegraph/srclib/archive/v0.2.5.tar.gz"
  sha256 "f410dc87edb44bf10ce8ebd22d0b3c20b9a48fd3186ae38227380be04580574a"
  head "https://github.com/sourcegraph/srclib.git"

  bottle do
    rebuild 1
    sha256 "65d468b529f68033a4cb7083ceb6cf0203957b95d3c856369ef9c681880d1775" => :high_sierra
    sha256 "3450a96b7d4af2d1e227b1ae188c29862fdfe1d007a49c2d88045b519a2110dd" => :sierra
    sha256 "0546a39d6f96c51817faffc1b5cc28fc5654dbf61ab165ee686b6a8093b0b359" => :el_capitan
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
