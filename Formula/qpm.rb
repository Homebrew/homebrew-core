class Qpm < Formula
  desc "Package manager for Qt applications"
  homepage "https://www.qpm.io"
  url "https://github.com/Cutehacks/qpm.git",
      :tag      => "v0.11.0",
      :revision => "fc340f20ddcfe7e09f046fd22d2af582ff0cd4ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ef0d236caf32a763f7c6dc717a47d23a99d2058617ed6ac151bc8b8a75fb881" => :mojave
    sha256 "af6f724ef7820ce62453edcd72f39b9c283554aa5bb2be091d37f48935fe7f5e" => :high_sierra
    sha256 "5c57c74e4079c59241e96b16f6236346efb4e358953f4c1edba359aa21d0d10c" => :sierra
    sha256 "316bf8d4802e252fe6ff20a1b1dec582968a0f5a34fde5001b6a92f7ad30dfa9" => :el_capitan
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
