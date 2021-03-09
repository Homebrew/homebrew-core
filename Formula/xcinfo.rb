class Xcinfo < Formula
  desc "Tool to get information about and install available Xcode versions"
  homepage "https://github.com/xcodereleases/xcinfo"
  url "https://github.com/xcodereleases/xcinfo/archive/0.6.0.tar.gz"
  sha256 "f1078911c5bff7d123d9e4020685669cae2e1bc74ed95dfefbb4da54b8132353"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "982250bfe51ef7014bdc668472b0e39f851fbcc73df81f8613893d56e23460ce"
    sha256 cellar: :any_skip_relocation, big_sur:       "215a7f21935a56b3ae73c599a3ab902255bf4e86cb7a5e0849fdd7aa9505f55a"
    sha256 cellar: :any_skip_relocation, catalina:      "b2479b9e14bfbe9457dc9d7f3265f3a1a2176c3224acfd3237867d5cff246f91"
  end

  depends_on xcode: ["12.0", :build]
  depends_on macos: :catalina

  def install
    system "swift", "build",
           "--configuration", "release",
           "--disable-sandbox"
    bin.install ".build/release/xcinfo"
  end

  test do
    assert_match "12.3 RC 1 (12C33)", shell_output("#{bin}/xcinfo list --all --no-ansi")
  end
end
