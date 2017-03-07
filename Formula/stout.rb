class Stout < Formula
  desc "Reliable static website deploy tool"
  homepage "http://stout.is"
  url "https://github.com/EagerIO/Stout/archive/v1.3.1.tar.gz"
  sha256 "455e238e238bf79f58d2e5a41f5ac582361c71a7eec72f45554f1c8f64de7006"

  bottle do
    cellar :any_skip_relocation
    sha256 "144aac3cb78b98bf773b19e63e7eb3598261ab264e30b6d39ee3c8fdb9442cf9" => :sierra
    sha256 "74dac56156c250fef9de8ebae64a1d6ae7b93c068a43f602a4debdc1b23a3945" => :el_capitan
    sha256 "bc065cf4232169432ce91ea22c456c6891f00a386055c795131dc82572f5a3ae" => :yosemite
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
