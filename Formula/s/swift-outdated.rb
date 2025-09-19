class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.10.1.tar.gz"
  sha256 "d2496a02c6261a72025d27e526cdbde25decee5fe790593f90c1661af63430ff"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0482349c35b684746603a83a31c53dd0b5ae228b7adc1a43e9f86410c7c5510b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4a414053cd019a301a7d60a0e0b8d86903ab05c467213d173c108c45a759e92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be7f055410b51f4c125edf24f19415e32a9a6f507df0b52756a3fd5976a90c8d"
    sha256 cellar: :any,                 arm64_ventura: "ac39a84605ea91bdbff7004218261f82f3ca82a2aa24cff8a56d110febb8a2dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9941516c564328df1f98b90037f606eac0f03a52590f373b1209edb6961eeee1"
    sha256 cellar: :any,                 ventura:       "82863caf05345ca7a98c08c0d63da43f123ec1a3d56e77a1437e6eddeb52860e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98d3305c2c7d7aa6fd1f2c4f9f142f4d361c4cd9029209961309b1851642d3b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a959433bb6fc3748c13003c3aebee4be103d43e0ec4afc70ba8c9e570dd5bb5"
  end

  uses_from_macos "swift" => :build, since: :sonoma # swift 6.0+

  def install
    inreplace "Sources/SwiftOutdated/SwiftOutdated.swift", "dev", version.to_s

    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/swift-outdated"
    generate_completions_from_executable(bin/"swift-outdated", "--generate-completion-script")
  end

  test do
    assert_match "No Package.resolved found", shell_output("#{bin}/swift-outdated 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/swift-outdated --version")
  end
end
