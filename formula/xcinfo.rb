class Xcinfo < Formula
  desc "Tool to get information about and install available Xcode versions"
  homepage "https://github.com/xcodereleases/xcinfo"
  url "https://github.com/xcodereleases/xcinfo/archive/0.6.0.tar.gz"
  sha256 "f1078911c5bff7d123d9e4020685669cae2e1bc74ed95dfefbb4da54b8132353"
  license "MIT"

  depends_on xcode: ["12.0", :build]
  depends_on macos: :catalina

  def install
    system "swift", "build",
           "--configuration", "release",
           "--disable-sandbox"
    bin.install ".build/release/xcinfo"
  end

  test do
    assert_match /12.3 RC 1 \(12C33\)/, shell_output("#{bin}/xcinfo list --all --no-ansi")
  end
end
