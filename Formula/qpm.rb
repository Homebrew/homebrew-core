class Qpm < Formula
  desc "Package manager for Qt applications"
  homepage "https://www.qpm.io"
  url "https://github.com/Cutehacks/qpm.git",
      :tag => "v0.11.0",
      :revision => "fc340f20ddcfe7e09f046fd22d2af582ff0cd4ef"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "e10b8209ffb5e0d36025c9aea3c53379628d4631d6bdaa46d0566625f8dede6d" => :high_sierra
    sha256 "6dab4a36e19b1cd7a6a898d516b0fc59289798213b97a2c06130b63f69243eaa" => :sierra
    sha256 "f2a77569109ea443de6fc94788906b1862ee183f3ecd6c065f7b05351f777eb6" => :el_capitan
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
