class Stout < Formula
  desc "Reliable static website deploy tool"
  homepage "http://stout.is"
  url "https://github.com/EagerIO/Stout/archive/v1.2.3.tar.gz"
  sha256 "0c4b10be84b2a2de18020215e49d59c380aba38a13d5c975c7f45d2b8e3cf4bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e1e825f22facc7e04295268f3bd36417f2fffd596e5d1c2d5b71c861172c035" => :sierra
    sha256 "aac5e3bac19e22e13d626a8d5b241659a9efd66267f970bd62ed0e394250c288" => :el_capitan
    sha256 "48cae1a0395e12fe8919269033a0bb7b7d2aa314aa2284f2390b7a01bc2fb4a0" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/eagerio"
    ln_s buildpath, buildpath/"src/github.com/eagerio/stout"
    system "go", "build", "-o", bin/"stout", "-v", "github.com/eagerio/stout/src"
  end

  test do
    system "#{bin}/stout"
  end
end
