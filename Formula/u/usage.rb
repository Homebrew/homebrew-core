class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v7.4.1.tar.gz"
  sha256 "64efd5e6d959ec82336ad84defec26b3dbf34ff917c4e38391db55656dd86488"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    manifest_sha256 "334cdbadf702abb16a716dacde223a5eec513aeec31ed712953d2094b5ba09ee"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9c568fb9b7d5c9f9cb06e53ee31c07294218bef5ccd6205f761bf2f9b5f27a68"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c93b31f83262bcea3b1410027960d804afb3d636fefe112f7a866a3e0e3fbf09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eacf1f551a392a2bf27276173ec87301fc5b45f579ccf24f73bc0417f017ce5b"
    sha256 cellar: :any,                 arm64_linux:       "de6dd06df2a53a1542b18b952d0b078114990a87dea6f43f8ba5f2eadf5375f6"
    sha256 cellar: :any,                 x86_64_linux:      "54c1c74e97701f87221e3d60374a829333f90649e4d5dc1e3d64e494dd684723"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -- --f").chomp
  end
end
