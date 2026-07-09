class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://ldomaradzki.github.io/xcsift/"
  url "https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "47aa9295c04e53033805c74069c73fe2d6e091f4ccbba5889c74bfe10b138294"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec142d86fa655ebc0d4024dfef55d255bfa2901b8708abeaef3f29f34338bc05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f62b48cfbc2d4d7384c6f24172b03be3b129ee69268864bba5602541c6d6a1af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21e4bf2f2278704cdfe56c052c04198d20a72f9b0ec28a5338a4ffc35cc89546"
    sha256 cellar: :any_skip_relocation, sonoma:        "77339974c2a08a80a272ea9b51d69d5f229a6ecc6b971267e13d42c6f2bbcab9"
    sha256 cellar: :any,                 arm64_linux:   "2de2b2d90ea995cbbf44ca575197a7908b183f169fe77824e780d49c744af42d"
    sha256 cellar: :any,                 x86_64_linux:  "5be4785031071d0b9821a9f010f33e6121fb01c25e634f6584a951b06abb8c82"
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
