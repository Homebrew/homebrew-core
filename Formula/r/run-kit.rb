class RunKit < Formula
  desc "Universal multi-language runner and smart REPL"
  homepage "https://github.com/Esubaalew/run"
  url "https://github.com/Esubaalew/run/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "853545b84145a34926b12d6526e517ba96f371a9f759652a50da7996ffdab781"
  license "Apache-2.0"
  head "https://github.com/Esubaalew/run.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaf7fb68e8e2c5cc7fdeedc670c10736e7374ed5ede262a13ab30c0299fb67fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "710f12d75fedc7767e518884637be70b5b68eb341c56b8df8743bccef86445a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42f460402611e4ffb4f4de60c3600ccf26c34b496852b7800f671bcb87105536"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcf8421fe8832e8de3036ebadcb06e23069a09826b3153d927e996949e7566c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d27037d42fd8f5ca31a314d0d6debfd4b439ffc49ef0e78de716285c1469dfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50a776d1b407e6d97bc20e5eb226e2f39a13ff524f04377f0bd20ac52d70f2e3"
  end

  depends_on "rust" => :build

  conflicts_with "run", because: "both install a `run` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "brew", shell_output("#{bin}/run bash \"echo brew\"")
  end
end
