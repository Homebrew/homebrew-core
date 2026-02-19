class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://github.com/ldomaradzki/xcsift"
  url "https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "857038dba673654632a395b8af058f064907c66d2046f66d59563062d22b4490"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81a4857dd01df195d376b76482dfcf8803fdb7e38738b50d323a22217f537e4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69890121ba3dd49b51a9e7531e0111949dd0ac00cbdbc2cfa64dcea319f208dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28301a99571733d6774e148679fbfea02a36148a6130212322888cec114dab63"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eedab3b3cb3dea428c674b7f1274454d89555bc80a67c418f58c89328c00ac5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1083730be86065bdbf4ac6488fc0c5253baa6c5092990b655fd7e5d0b75e96c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "959f75804966af21498003f9eface64f94ec6e831b8d0df09d1635c948ccf5f5"
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
