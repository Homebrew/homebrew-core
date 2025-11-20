class Typioca < Formula
  desc "Cozy typing speed tester in terminal"
  homepage "https://github.com/bloznelis/typioca"
  url "https://github.com/bloznelis/typioca/archive/refs/tags/3.1.0.tar.gz"
  sha256 "b58dfd36e9f23054b96cbd5859d1a93bc8d3f22b4ce4fd16546c9f19fc4a003c"
  license "MIT"
  head "https://github.com/bloznelis/typioca.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4dad0118007da9cd8ba1062735f66af73057d2b7d75bef2f70d4580ba5a2412"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d67b7e8e8f4bf06519b363da75af9c40805aec9a4a11373cd464d9d3acd59785"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d67b7e8e8f4bf06519b363da75af9c40805aec9a4a11373cd464d9d3acd59785"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d67b7e8e8f4bf06519b363da75af9c40805aec9a4a11373cd464d9d3acd59785"
    sha256 cellar: :any_skip_relocation, sonoma:        "001224a612f62adb17c03bf47007fa8fabafa8b3005be2f48db19cd311a4bcdb"
    sha256 cellar: :any_skip_relocation, ventura:       "001224a612f62adb17c03bf47007fa8fabafa8b3005be2f48db19cd311a4bcdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5bffa9dabacbb6821255070ca8449be5960ac8e895b39eab13eccdad7d1ba85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23a8e545f920e97d3dd4cf38f12ddf5bc4f2d62af406c2e7d27daa7501b12e5c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/bloznelis/typioca/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"typioca", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/typioca --version")

    pid = spawn bin/"typioca", "serve"
    sleep 1
    assert_path_exists testpath/"typioca"
    assert_path_exists testpath/"typioca.pub"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
