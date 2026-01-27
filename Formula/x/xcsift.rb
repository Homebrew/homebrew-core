class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://github.com/ldomaradzki/xcsift"
  url "https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "fc00593a3f3fc67cab0059c4b3271550e42e0a4c555725ce0aa70f327cee2f46"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "893392dc08ca633b61597b2885e74780c3dd9847c561bc6f549a09e400c000c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7f153e6c15eba25290fd35c36cd7647c36f27234db2d4817c80a23701cfd0ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70a3219d795d620044bd203c26305f4bb6b7ef2828ca9f091bc974bc4912216e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5730c2efa39b7f2dd5ff4c9e9b3437efc7c93e333f19e08b1c60797426db4146"
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
