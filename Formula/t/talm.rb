class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://github.com/cozystack/talm/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "459b97ccbbd76f4daec83b95dc6f4ffc4f1563b60623323e0a4d2e1f7f0c3f79"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa184a0a78a0e492ac0e31f91bd3e6b848c2ee8a13c3c03c33b5e04314df42d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "093605a417b9f7e2e8bef5a64de4b4fc7f1d61285d78075a8f14f236cb20f2ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7836b4c613a73ba46258f3c6977a7c8ce5ae4ba1a274928031abb22debef138"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a8fbc96a20e24797ed6d48a9ed26f832617cbc3fc9c8e001577d755b81b6a98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ad454982bfd720343c01764e6613fa3a1aee0af468ad70c65e895ae553b7746"
    sha256 cellar: :any,                 x86_64_linux:  "314f67dca38af98c692290742f6f2247481485fca9ad10d7b405e9f140dcbb2e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")
    generate_completions_from_executable(bin/"talm", "completion")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end
