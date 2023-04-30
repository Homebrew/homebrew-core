class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.7.0.tar.gz"
  sha256 "1ef57173057c922eb71baaaa5329ab78fd59449f3bca2b129d2d28588f4a3d9a"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb51000f032c2cccc9173d690edf7f1cbfb547bc8dbba40161e2849ee50b035e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "299bc502a158f6254414065522c3bbcf452f2cf80a943a607651b53c7492cae8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d0222d5620acd09dc93c48f0d0075e982f000ee73aea00048827f1d9c52caf8"
    sha256 cellar: :any_skip_relocation, ventura:        "72cb4b5d035df04d2792d41a3334bcb6cbc1c417d6341cb2f601ada4bb1fe75d"
    sha256 cellar: :any_skip_relocation, monterey:       "cdcf8e6879d872e58d28333a059e86dbd2d61ddbad066bcc73248473668a44a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7fb64d81ca7c5d495bed3d621c3a2d403b19eac0cdb0c826f73eb8c7c443975"
    sha256                               x86_64_linux:   "c387415dafc0eba81409dfd847786ec3c56284308f7289c0280b4b9cc8cc6b22"
  end

  # vapor requires Swift 5.6.0
  depends_on xcode: "13.3"

  uses_from_macos "swift", since: :big_sur

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
      "-cross-module-optimization", "--enable-test-discovery"
    mv ".build/release/vapor", "vapor"
    bin.install "vapor"
  end

  test do
    system bin/"vapor", "new", "hello-world", "-n"
    assert_predicate testpath/"hello-world/Package.swift", :exist?
  end
end
