class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.53.0.tar.gz"
  sha256 "5a665637608d432e357e30ad62201c65131dcc7d97ce175ce8fc35033bc7ce69"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ac7296e9c503e41de46a43dc032946f51c2939e548cbda892f4bfd552eb9831"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbd7ffcc68e6f93eb2301b3daca50c3a334e3b01186c065d121d339199d49dab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48c958e3afca6df5694914787062a83d29f90f5f64f5bec951a65d940dc2313d"
    sha256 cellar: :any_skip_relocation, sonoma:        "db276e47fd759cbd450db8c4f151e450567c6252002733df9ed0ea92cb1bf29e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4162567d47fa8779e51080e6729df5b15a9b0c2385587a190f35e42bba996d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bbf9ea0224993f7aeee6f2e3d0937c93b76296cbae9179bc75a59ebe644c31f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
