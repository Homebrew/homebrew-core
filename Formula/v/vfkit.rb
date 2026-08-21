class Vfkit < Formula
  desc "Command-line hypervisor using Apple's Virtualization Framework"
  homepage "https://github.com/crc-org/vfkit"
  url "https://github.com/crc-org/vfkit/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "ff496bd6ee6772ed070f286c4282a8a2e2f5231d4f8e98b2255b883ba69af42d"
  license "Apache-2.0"
  head "https://github.com/crc-org/vfkit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edc280884decf90f3544f21534610bf70bfdd9cda6c3d3177059778432390a81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3fca0c9bb4db4dbb061b8af9d998195db6c675aed00255b5db72f8d07d8c657"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22cfba330578f4ded8a1a6d150c7e89229e2e5154a4d89a6f4588c47c3f30ab5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c808cfc48ad52cf87f761575e98e0f85478cf0ec432042f4c426450fcd54e7f5"
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
