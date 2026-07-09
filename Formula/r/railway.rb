class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.26.0.tar.gz"
  sha256 "ea5ea09ed149fa5e7f84646045b7d9b17d91aa84d4e7a995dd3716099869323d"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48ab1ec723880345a294e7bd38036fa00f9d64ad8befb232cad306ccb3caea93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebef36327c31ab482ef4389463636012be2dc9a6e92dd18379ded9241b80fa82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83eb3842a06f94780ad34fb48857ec273dda51ae16d794822914923d8a65db91"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a0a3f7dd6bc3dbc8067e6c3ad3c0e68a75b83aad9ef93c08589f2b050089ee6"
    sha256 cellar: :any,                 arm64_linux:   "7b2f23d1de215d58ded17c203ffb58762b8d971c65b614a7bd120c3d8f0e42c9"
    sha256 cellar: :any,                 x86_64_linux:  "9eb02c0506adc63edba86f8554861fbf88e8c276b1b7c98194cb48bc34e9e6dd"
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
