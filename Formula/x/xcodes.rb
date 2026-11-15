class Xcodes < Formula
  desc "Command-line tool to install and switch between multiple versions of Xcode"
  homepage "https://github.com/XcodesOrg/xcodes"
  url "https://github.com/XcodesOrg/xcodes/archive/refs/tags/2.2.0.tar.gz"
  sha256 "29fcc60507f1b226d1a7384dac34c2b0e56067575bb428fc7bb2d3d030683fa9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "81c13eb2a30b3eaaa45888af463df13ca68dca033d665dfc92be4544ad65b199"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "95c6a67be6585a93475dd06bee1b8060d4a6673a7f83c8313962c97acbe98d90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a072effea08e3d25e19cce9b838ed0d176f5fa178bb32a818aa05c904a3bb1c5"
  end

  depends_on macos: :sequoia # older SDK fail to build on non-'Sendable' type 'Logger'

  uses_from_macos "swift"

  # `test do` block fetches the list of available Xcode versions
  allow_network_access! :test

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    system "swift", "build", *std_swift_args
    bin.install ".build/release/xcodes"
    generate_completions_from_executable(bin/"xcodes", "--generate-completion-script")
  end

  test do
    assert_match "1.0", shell_output("#{bin}/xcodes list")
  end
end
