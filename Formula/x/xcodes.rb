class Xcodes < Formula
  desc "Command-line tool to install and switch between multiple versions of Xcode"
  homepage "https://github.com/XcodesOrg/xcodes"
  url "https://github.com/XcodesOrg/xcodes/archive/refs/tags/2.2.1.tar.gz"
  sha256 "b498c1fc59e649a771a48631d45a978e6d8feadebc6de13b99cc737343e181a6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "b1ec95da3a3be232bd5f15c348b4a9bdefea47d7f0e866761c9033c87de7a13b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d777effdc52421eb8a02fe7aafbb2d29d1c91fa48b5b3da3bc2235bf70a42ab1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "782c02a9dc9ededdaf4e6a0ed4c26a9fd47fd10be6e4f049add8e3d502248444"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "03c72ff6484f60faf9b0108fd6de11fd40067d49c5a3a2ce1ba46bcd9c283612"
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
