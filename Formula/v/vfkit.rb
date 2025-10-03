class Vfkit < Formula
  desc "Command-line hypervisor using Apple's Virtualization Framework"
  homepage "https://github.com/crc-org/vfkit"
  url "https://github.com/crc-org/vfkit.git",
      tag:      "v0.6.1",
      revision: "97c536487a40f137bc12d6561aa70625a54a4b08"
  license "Apache-2.0"
  head "https://github.com/crc-org/vfkit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b6a2d79218e58d4326d9d4414d3459457a5fca8556283170fa621dbe46d5db0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc4052299d0269c894dc734cb606a28fab6b9de085afeddcf81bb4fa2d8f0f54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f22e5e7f36bcfa133de94570777eddeb5b3cd7a27a01772e460c2f2f10de24f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "327542e26cfe0a498e0270fd04f1c7ded2d97426d881a97939df9631f981b5b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0907b22ba995891cc690e90ccd37cc329a72d79f59418f12f34ea2401594a18"
    sha256 cellar: :any_skip_relocation, ventura:       "174f80e56113503f461402d391682e90ed602597c678b5459095c62faeaace47"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    system "make", "out/vfkit-#{arch}"
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
