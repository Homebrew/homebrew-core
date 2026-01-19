class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://github.com/ldomaradzki/xcsift"
  url "https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.0.23.tar.gz"
  sha256 "aec03041531fb891749d4862571355e92aac5acb18c9a21c0da9a9c7f712fde3"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59fd9d69092840f7ec5410d59ab6bcfc39915ad6fe922a329c8941ef8fa336a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59067dc3e78db2048d0b418ee17ed99e596ee41cfaf13771b939651bdd745b71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a8f69470f019aaee975e520ceae801f8a536f2271dee1803861c723e992ea44"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1c8c3ddf626055dc7ece89c6078aff0575287503d356e0054d5f4784cff4ce1"
  end

  depends_on xcode: ["16.0", :build]
  uses_from_macos "swift" => :build, since: :sonoma

  def install
    if OS.linux?
      # Remove TOML/C++ interop dependency (Homebrew's Swift lacks libswiftCxx)
      # Config files won't work on Linux, but CLI flags work fine
      inreplace "Package.swift" do |s|
        s.gsub!(/^.*swift-toml.*\n/, "")
        s.gsub!(/^.*"TOML".*\n/, "")
        s.gsub!(/swiftSettings: \[\n\s*\.interoperabilityMode\(\.Cxx\)\n\s*\],?\n/, "")
      end
      inreplace "Package.swift", /,\n\s*cxxLanguageStandard: \.cxx17/, ""
    end

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
