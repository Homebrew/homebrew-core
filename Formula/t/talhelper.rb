class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://github.com/budimanjojo/talhelper"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v1.16.5.tar.gz"
  sha256 "a6727d83bb1ca99bf9917205f833d198de1c496b36741c79784e84aa5f15b3d5"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d89692823895dc73562efa7731e9dd51fbe3263c6f05c0dbe70892bd370df92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05f0bb30ac3b445ffcec6dd77ec05e94cacc4679ccc5daf12ec6c953acd02d35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b7e4a416b2f02dd4d601b6c852feacf246fe873175103c6e6b86d7a132d7232"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ac945cfdba07c3dbf33443bbd7b7d392c82d9a68a4a985eb9514e0a5d084c04"
    sha256 cellar: :any_skip_relocation, ventura:        "259a386ac2bf1da14df234b6b8e7dff40eb46a410df94d848fcaa55d393bbe2f"
    sha256 cellar: :any_skip_relocation, monterey:       "0ba10b27b0a4997c4704e531d3ef6daafd0d5bc037dc44d369856418572551dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ae7ef4d7fe77d6bcf1fb6aef5b142950d6f3d7438aff9195255d78fcf8ace88"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

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
