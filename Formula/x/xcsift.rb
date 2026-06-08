class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://github.com/ldomaradzki/xcsift"
  url "https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "d251e0912cd0f0b2b4e3c25a9a9f29c032ce7dcd770d8ba583325744229390cf"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78d6aed832ed8a45fe1518ff3f2246056edec27dd17d90b0d6de75a3d24da240"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20947f465ae4c3981f3d2227500103aecbfcc441decdc858399aac057d8b11b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "627251ad8568e9502cb2b931ee543d4f4a0b41a003a3a79da4454a75bf0eab6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f2fae12e9171a80b650e709b22785027a94a48e62034c34a405054fe4b16b77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b58ec68c53a6aa66a31a12b6cd326fea69127d2706a4f1566459c537316c5bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ecf262656a3188a0fedef9626681107b329a0fdeb316d5c3a007ced0f54866e"
  end

  depends_on xcode: ["16.0", :build]
  uses_from_macos "swift" => :build, since: :sonoma

  def install
    inreplace "Sources/xcsift/main.swift", "VERSION_PLACEHOLDER", version.to_s

    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end

    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/xcsift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcsift --version")

    output = pipe_output(bin/"xcsift", "Build succeeded")
    assert_match "status", output
    assert_match "summary", output
  end
end
