class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://github.com/ldomaradzki/xcsift"
  url "https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "a26a8f499e82313368b53b880f5f1d7f42e2b330658a1a6faf3a224bdfd5d570"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d540905a9653f343f86c2f3a9a78421a5e23988d94e22c21d5f8f7e8a64de7d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b53060a61510af3335cf425f389c9731a37f634a50572faa0c5a208f23a879b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b0e226dc354705ec313cfaf6f1077cc90622bf7338c4dc178e621eacfb6adc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d3dd70b68f93a866a9bb6b7b307f8c7f3f121e2c9f40a54896f1dbbacc65844"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36d56402afd5dc8cc6a7431cdea738aa6bd28fd1dcb7ecb8f54cdc46a16d2c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a415f16e8074b92572305b183fb685e5bf1155a2cfcaae6796b1855e1cde44db"
  end

  depends_on xcode: ["16.0", :build]
  uses_from_macos "swift" => :build, since: :sonoma

  def install
    inreplace "Sources/main.swift", "VERSION_PLACEHOLDER", version.to_s

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
