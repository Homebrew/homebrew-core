class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://github.com/ldomaradzki/xcsift"
  url "https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "b5e9540d505f7aa1fd1069bb637884a66b178f801cf5ee8086ec68ab923173c8"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b0c637d527f25851ce40e076af35b2ff8fb5c3efcaf5c22a1dc6f8482858c01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1308356636baf20a53c6dafd36b6b43ffa401e5e5788e8e199e1fca0a800b900"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30b8ff57e0780c9ecafdaa09d8f24fc84ae38448815edc722c66d91232acaa3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed0d6321296d6b1b28dadab7257fab56c3eed6a78764ebaa1ae230bde02f5da8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c3785be540c89595a35c3d3fd880b7220bc8315860d28d739f0f2ac37535b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8eef65dc9f662041abdc63ee7519b70876792365a819e94e80fa4dfe6fd952b"
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
