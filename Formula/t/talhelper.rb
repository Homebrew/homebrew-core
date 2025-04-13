class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.21.tar.gz"
  sha256 "4ec52428117a00e0fef829416a435f5ede839431b74f751c8d5f7d6b96b46df6"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2698163a3680b48e3c048a7498ad8226af42c1f0dec3bb7b8796d29f2c7ad2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2698163a3680b48e3c048a7498ad8226af42c1f0dec3bb7b8796d29f2c7ad2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2698163a3680b48e3c048a7498ad8226af42c1f0dec3bb7b8796d29f2c7ad2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f2eefa855be9e50150766c7346451acfad87617a8998dafbcbe87aa94ffde9c"
    sha256 cellar: :any_skip_relocation, ventura:       "4f2eefa855be9e50150766c7346451acfad87617a8998dafbcbe87aa94ffde9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "133f43df89fb35cc0db4df43a25de3f5b935d30e5fcafdfd16a6a09ccd2fe20f"
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
