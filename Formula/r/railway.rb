class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.8.0.tar.gz"
  sha256 "e7c84f697e96a671bc05ea6d6a407595fabc684f0baa16a9f9192d2a7db4274d"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82ceaf5e37e35294ba4831bd381cac11e750e31153bbaacf207bd7cba02edc1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e6285e53756b4e913736141a4eb2784048a0623e2219accb43b0ef432e035e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b9bb0601ed9fd1cfff883933983c42c590fc3d553992024044b918916cf0e51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "509cc3a4b737ecc1073e286a70c9b5991212e6a24f412426904e5faeee491e60"
    sha256 cellar: :any_skip_relocation, sonoma:        "58f7c8681fe3def67ac84b7c2958005283af59a219ab29c24a918f2fc9bd0618"
    sha256 cellar: :any_skip_relocation, ventura:       "a48fa2209477189a0bdab7012babefdf2da1c264a9433546523bb0b6883ce101"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f6206d90fcc115370c4bebfaa0fb1bdcd0f1b4881811c38e17b9b4c3a63c085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daadbe996a066a912aac7a070553685cd5f6ab1eecbc1dd39eb342f42a0d1112"
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
