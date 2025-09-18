class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.35.tar.gz"
  sha256 "27e509a301b2f4d147311b81757840ae9eec659c54bf1bf8403987b68c07528d"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ac862a32f65b05367fe5f2d13aeae2aab7254303ddf85cf58e2e1e0b3eb06ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ac862a32f65b05367fe5f2d13aeae2aab7254303ddf85cf58e2e1e0b3eb06ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ac862a32f65b05367fe5f2d13aeae2aab7254303ddf85cf58e2e1e0b3eb06ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd693d57bd4c7561ae4f2c7c2613b311482e7a555411da2da0c537a0feb03451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09f28d7dabb0bfd5e07d42d382856290b7c444b03cabb65cae44c9831cb5fb9b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end
