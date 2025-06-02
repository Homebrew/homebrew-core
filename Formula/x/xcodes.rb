class Xcodes < Formula
  desc "Best command-line tool to install and switch between multiple versions of Xcode"
  homepage "https://github.com/XcodesOrg/xcodes"
  url "https://github.com/XcodesOrg/xcodes/archive/refs/tags/1.6.0.tar.gz"
  sha256 "415c104c1aca42e68b4c6ede64e543d79a60d5a6fa99095f2aad179a74045047"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0bfcfc461c00b753ca481a0a3e1d7997c5eb940389de08895ee673c1a0e2612"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1913afb72f753a182a4d3d66f08b61f0abf2de924b93e3ad42f20bcf95260fa5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07d06a3446dba98e8b62bf31da5bee4b49a7f3d5215baf269ef78f4334ce222b"
    sha256 cellar: :any_skip_relocation, sonoma:        "86ff1161c99af9f9fad6d8d38bd2a8cea1a53a8764cc4368770e83bf136ba22d"
    sha256 cellar: :any_skip_relocation, ventura:       "7c00b27bce8dd91695740061ec9d5d4cd54faec6d7d7e18016723e2619fabaff"
  end

  depends_on xcode: ["13.3", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcodes"
    generate_completions_from_executable(bin/"xcodes", "--generate-completion-script")
  end

  test do
    assert_match "1.0", shell_output("#{bin}/xcodes list")
  end
end
