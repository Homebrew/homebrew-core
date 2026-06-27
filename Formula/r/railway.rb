class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.23.1.tar.gz"
  sha256 "e0e38bc3fd7cfad4495a87ae9dd8c631654d092bca3b5ea555ed6d189ca94ee4"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4669d2c2b2281e1bf2e7619dfcb0c0d49f796cae63fe77507dc5199f0f26afe7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b71db17842f1ad238cb6692dbe2b58564effb08f3cdb528f74848764d5b9c9cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "523f81b5451e7001a61d53c9dba5679a7ca231919bfb26f8b7fb4ef0d5baaeb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b5f07dadc46db7596e69161048772201fde959f631ed818c3597f69de17846b"
    sha256 cellar: :any,                 arm64_linux:   "e2fc34f7a353e745fdccd9ea51c0dd18ab51b07867755e0a0db60a15c7360892"
    sha256 cellar: :any,                 x86_64_linux:  "98e0c11861f1c29f5524ebe23d56cd69e4dbac884592cf8650ec9d2b0f36f1c4"
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
