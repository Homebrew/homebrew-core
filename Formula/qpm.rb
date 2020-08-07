class Qpm < Formula
  desc "Package manager for Qt applications"
  homepage "https://www.qpm.io"
  url "https://github.com/Cutehacks/qpm.git",
      tag:      "v0.11.0",
      revision: "fc340f20ddcfe7e09f046fd22d2af582ff0cd4ef"
  license "Artistic-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5d5edc32931995dfa82429a1d8708e700de70208f36767808a433c1e9bb2ffb2" => :catalina
    sha256 "f8208ec60e2af6e9d1da2caa0ad1b48b5b027955c2daa51860fa1606b8c5acef" => :mojave
    sha256 "8c9d0dde0b7a4292f8fa04337805755ac16ce1aab08710463323afec2f73d551" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src").mkpath
    ln_s buildpath, "src/qpm.io"
    system "go", "build", "-o", "bin/qpm", "qpm.io/qpm"
    bin.install "bin/qpm"
  end

  test do
    system bin/"qpm", "install", "io.qpm.example"
    assert_predicate testpath/"qpm.json", :exist?
  end
end
