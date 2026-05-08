class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://github.com/cozystack/talm/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "16cd8b56ba56c22af6cc4496cce2a864dcdc95fff3ab650a71b7d30759133ea4"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f86a6871f63eaf7b15908fb18c50c0ddc256ee8b3f1ced804d45c5ed254f4f89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6615a8a7ff58cc1ef5023a7c9d3e6832514f5181ee9781f4bcb7259a0b16f729"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8359ca91ddd9fd2809e5a24e112ef82b9be664cd96d0e99f42e2aede966f24ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "855b42bf043d6f3940c4b19c502e8323c4a55c40b110741538f26f33a9cffaca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5f2072ca9487f99c5f9432aecd43a4c390e64adb7b831c089a9f77e9ff24be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ce5425057c2066aa428ecfc54237daef05c91990c7b863f9ff1c14c5c97bfef"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"talm", "completion")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end
