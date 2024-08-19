class SwiftSh < Formula
  desc "Scripting with easy zero-conf dependency imports"
  homepage "https://github.com/mxcl/swift-sh"
  url "https://github.com/mxcl/swift-sh/archive/refs/tags/2.4.0.tar.gz"
  sha256 "5255e497d985fbbe2df44ed69ed1552b43fb58c175bd2dd254b52e5cf888d629"
  license "Unlicense"
  head "https://github.com/mxcl/swift-sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68b78e155165e512e75065b689f34c4bdd290e014d16a75298b6869484e6e29a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7544737098ecda67ac57df17568121bb3875c1773a0e276c49298c33475f9866"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c18ed52ff47b163562ceaec064b64bdaa474fc7b96679f972aa6a5859da3d912"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d67e477cf1645b1eec138b94e5e4ff40e477421fecabe7a3f9959e14ed7bbae2"
    sha256 cellar: :any_skip_relocation, sonoma:         "be9d4724adc27a4767aaa02b399cae407935694965fe14d339c9baff780206aa"
    sha256 cellar: :any_skip_relocation, ventura:        "c5d18cbd7bca379a34b918ade17f576c3321b31cbc7ab19b36af1f874b2fcbf0"
    sha256 cellar: :any_skip_relocation, monterey:       "0cab36a85f37f26946b2c6dc4ef1672c6aa892fdcf8fd69eb64a35a1d283be10"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed4fc395a22c3ad54255cb55756de1a2e95605d7cc09515f79a892f56ca99852"
    sha256                               x86_64_linux:   "1bb33c15a6225672861ef3e3ab515634dbdad7342dce3cd0594e7f9a84c38a9d"
  end

  depends_on xcode: ["11.0", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/swift-sh"
    bin.install ".build/release/swift-sh-edit" if OS.mac?
  end

  test do
    (testpath/"test.swift").write "#!/usr/bin/env swift sh"
    system bin/"swift-sh", "eject", "test.swift"
    assert_predicate testpath/"Test"/"Package.swift", :exist?
  end
end
