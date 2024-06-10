class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "583da50dde457c4ab4f1bfce0d4c0bd23565d26d9e0f8be1cd2530ae6c8b1042"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb786d784456de04df72328a503ff14e015de8e98d540b4cfe528641b1b192b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "549b4ac335bb5853bda758919d3c435d9d79fe071b0e4914040479ab13d6b793"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a23d76a60db88faa12eb38f55dfa5d6d76b38bc3a61bed8d964acf12fb1947a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a0c820244856f9951a6c3c6d97bd78b06641e2734f49d4974b2cb3351fc2e47"
    sha256 cellar: :any_skip_relocation, ventura:        "e997ecd22c8fea95fd376b4fe1f7099f03dcce1d46f373ff8ec10d575af69755"
    sha256 cellar: :any_skip_relocation, monterey:       "1689dfb617adfa969dfe8f21d951d04178f244175c13e94cb98cb566ae28a6d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d566593c657e30ccf880d5b41c1dc4e5d0431f470ce4968018aca35c69dff7c3"
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
