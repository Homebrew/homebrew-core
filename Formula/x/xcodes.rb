class Xcodes < Formula
  desc "Command-line tool to install and switch between multiple versions of Xcode"
  homepage "https://github.com/XcodesOrg/xcodes"
  url "https://github.com/XcodesOrg/xcodes/archive/refs/tags/2.0.3.tar.gz"
  sha256 "ecc37bc69a6eb343a3c58f5edab42169bb2c4d38266b6585dbf5738d3eb59eda"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "293fc783fe123d6964c9d7bf5e06d020e04c98c3e2b8d98183a6fbc65f868527"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c372609e4c77866cb942add04f9f45d7f5cab96dc819a513ba26c9fc823aa26b"
  end

  depends_on macos: :sequoia # older SDK fail to build on non-'Sendable' type 'Logger'

  uses_from_macos "swift"

  def install
    system "swift", "build", *std_swift_args
    bin.install ".build/release/xcodes"
    generate_completions_from_executable(bin/"xcodes", "--generate-completion-script")
  end

  test do
    assert_match "1.0", shell_output("#{bin}/xcodes list")
  end
end
