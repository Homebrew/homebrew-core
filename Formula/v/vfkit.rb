class Vfkit < Formula
  desc "Command-line hypervisor using Apple's Virtualization Framework"
  homepage "https://github.com/crc-org/vfkit"
  url "https://github.com/crc-org/vfkit.git",
      tag:      "v0.6.3",
      revision: "c8f5851f0ec131f04030925ea7ad15cd4e43876b"
  license "Apache-2.0"
  head "https://github.com/crc-org/vfkit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3953a8b58decd41c83de7686212202184e575c3d45bfad7002a7033549612bab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fecae760b337abd886f5e0c414aa6ac4be681231f55d50696b9abd485915cd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "343cd8954cebd64b329487f0ab292d213247eef5026e431cc2e50bb4eb16257c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee7116feaeeb5feea19c876d8a5f157bf646af00f8dc2d1033965ff5a8c50bfc"
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
