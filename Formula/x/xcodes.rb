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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b234d9cfa8f54e794d091155dd3f693bf2be283c106baeb6cd8909410b4e2c28"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4e444c7040ed0f65615ad1768252889b4f9a3c3db43119cf9c295767a6b28ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "18edd88606b462f58243839cf31b4dcbeb3eafbd7520bd989c89d3e261ca9958"
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
