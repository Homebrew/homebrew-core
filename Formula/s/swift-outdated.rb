class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.11.0.tar.gz"
  sha256 "60a82a00446151359962754d34ab0d1dc41cbfa71ac6e41ef9e38f45bad66ccb"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4f66dca24aa12662cb6a24db12b9230e422f3c5cf4b9f7b2f1e6d869967f08d"
    sha256 cellar: :any,                 arm64_sequoia: "6f20c6942bee2884c5000eca4bca3565443489f45e857bc7d54001cbe7fda382"
    sha256 cellar: :any,                 arm64_sonoma:  "fe3611cd4601f9766824f6fe9d1f76baa6ca4d70cbd5d6b8e0df077944376105"
    sha256 cellar: :any,                 sonoma:        "483e5440044df796bd31cbf9d860ff580dd621494fb724525cce4fef5c72a9fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3729f576e3636160c37316d7aa7788cbdde8dc2c999651654c0a16439af019d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1ecfe9c2f5011cb9317a1ecf20b52ce93dd4dc25786b39d6acc7a7d60497b12"
  end

  uses_from_macos "swift" => :build, since: :tahoe # swift 6.2+

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
