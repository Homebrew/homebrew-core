class Vfkit < Formula
  desc "Command-line hypervisor using Apple's Virtualization Framework"
  homepage "https://github.com/crc-org/vfkit"
  url "https://github.com/crc-org/vfkit/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "bb2a7f9d1bf41d2f823412ca20912bade606ae30b41afcd1366d32e3d100a09e"
  license "Apache-2.0"
  head "https://github.com/crc-org/vfkit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2b457cf9a83db240fd8cbf8da42696559ec98dcb0df8bae65e10d9639c67a2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbe1419e8154b9ffb4372c29e91570cb3f7551570c558615da7ceec62ca894ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cc27e2bbf85e2d829c23dad01b56673bf992851ce1c29c701210a8c19f81cc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "14299743d19df1a3b719e471dff77e67c864db71e0b6b043f42a90b33ca81b60"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    version_ldflags = "-X github.com/crc-org/vfkit/pkg/cmdline.gitVersion=#{version}"
    system "make", "out/vfkit-#{arch}", "VERSION_LDFLAGS=#{version_ldflags}"
    bin.install "out/vfkit-#{arch}" => "vfkit"
  end

  test do
    version_output = shell_output("#{bin}/vfkit --version 2>&1")
    assert_match("vfkit version: v#{version}", version_output)

    # start a VM with non-existing kernel
    output = shell_output("#{bin}/vfkit --kernel foo --initrd bar " \
                          "--kernel-cmdline baz 2>&1", 1)
    assert_match("foo: no such file or directory", output)
  end
end
