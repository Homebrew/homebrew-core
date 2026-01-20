class Zadark < Formula
  desc "Utilities for Zalo"
  homepage "https://zadark.com"
  url "https://github.com/quaric/zadark/archive/refs/tags/26.1.tar.gz"
  sha256 "8465c97494dd460a95529ad065077da2b8c1431f77d8a00adc4fc5733802effa"
  license "MPL-2.0"
  head "https://github.com/quaric/zadark.git", branch: "main"

  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on :macos

  def install
    # Build from source
    system "yarn", "install", "--frozen-lockfile"
    system "yarn", "build"

    cd "build/pc" do
      system "yarn", "install", "--frozen-lockfile", "--production"
    end

    # Use pkg to create executable - must specify the entry file, not directory
    target = Hardware::CPU.arm? ? "node18-macos-arm64" : "node18-macos-x64"
    system "npx", "pkg", "build/pc/index.js", "-t", target, "-o", "zadark", "-c", "pkg.config.json"

    bin.install "zadark"
  end

  def caveats
    <<~EOS
      ZaDark has been installed successfully!

      Usage:
        1. Close Zalo completely
        2. Run command: zadark
        3. Follow on-screen instructions

      Documentation: https://zadark.com/pc/macos
      Support: https://zadark.com/contact
    EOS
  end

  test do
    assert_match "ZaDark", shell_output("#{bin}/zadark --help 2>&1", 1)
  end
end
