class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://github.com/ldomaradzki/xcsift"
  url "https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.0.21.tar.gz"
  sha256 "b7d5fe3d1838a59545aa5ec3948227c64aaf0bdb92b760661d4f0ec546476db1"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  on_macos do
    depends_on xcode: ["16.0", :build]
  end

  uses_from_macos "swift" => :build

  def install
    inreplace "Sources/main.swift", "VERSION_PLACEHOLDER", version.to_s

    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib", "-Xlinker", "-lstdc++"]
    end

    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/xcsift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"xcsift"} --version")
    assert_match "parse", shell_output("#{bin/"xcsift"} --help")
    assert_match "xcodebuild", shell_output("#{bin/"xcsift"} --help")

    sample_input = "Build succeeded"
    output = pipe_output((bin/"xcsift").to_s, sample_input)
    assert_match "status", output
    assert_match "summary", output
  end
end
