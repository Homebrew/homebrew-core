class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v2.4.0.tar.gz"
  sha256 "b5f1253d51d98ccbb1cf1b71436f60f75fb2765306f0401b57c12acc0603c0e1"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82220427be0b2723dae6802e30d6d624df15a4fd6973928cc7d768a2435aaeb9" => :high_sierra
    sha256 "ed7d2006ca7f4ab22f34f9fb419875486e8ab23fe74456d5fe5690589d840a55" => :sierra
    sha256 "085555d1c1bddca1c61b51767664f6a4838e6269551bd9bb548687426ea968de" => :el_capitan
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
