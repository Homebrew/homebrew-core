class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v2.6.2.tar.gz"
  sha256 "69f5a801239299be95b26aa9342339432934eb49c41137022ef39aaf58c903da"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d403eecfe666f891ebb45bd8f3c1abe0606aacb52d90fb00bb6bd52655b60744" => :mojave
    sha256 "5c73f29186224ade6113238743d690e57c5fe318bac9da712116fb6ad3c5fd37" => :high_sierra
    sha256 "38e606c8d8edfd994c665314735e66603f33de6f34ac6d98b7d80da308ed3a75" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/mvdan.cc").mkpath
    ln_sf buildpath, buildpath/"src/mvdan.cc/sh"
    system "go", "build", "-a", "-tags", "production brew", "-o", "#{bin}/shfmt", "mvdan.cc/sh/cmd/shfmt"
  end

  test do
    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end
