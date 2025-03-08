class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.22.2.tar.gz"
  sha256 "36351c647e83d472ca3619aef87a1ca96b13d4e812ef19e47de633a52bbd58c2"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "736ef38fe9539470658b0744910592bcafc5c05551e6c0c0164fc059a6b877e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c1e12c2611f140db0ce7a165f5883263e36eeacaa5913fab552b37213996d5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d08eb556620d13d2ddc139698b2a0cefd3046c3f0329413eafb991da451dd026"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a0b3401c5f0fc1bb6b40321eaff91fe6b3a3eed6bcc680db02c6ec2c73d00bf"
    sha256 cellar: :any_skip_relocation, ventura:       "13159b1c4d2468a832ce89d6094295eaf703b33bb11949ec25be7e099fd1c197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7da253178ab9c4ecae46646965abe946d9d3a32d7f1005a24aea4893fa46d4c9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end
