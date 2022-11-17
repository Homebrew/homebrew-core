class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.22.0.tar.gz"
  sha256 "3726e3c6a0e8c2828bce7b67f9ee94ddbedcfbeeecf9e6ab42e23873e3f54161"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5c169b70031f867d167d50b6cc48e1ac2cd1cf43cffe1fb2c2b4a9c41470d78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65a3d21674e3bcfd264e85d1c97a5aa15343c2fa4610d540706ea91df0ba5af4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea3cca066c91689c2b9dc2abd907a990914e8128a8ec4a5028cc2b939f254ecd"
    sha256 cellar: :any_skip_relocation, ventura:        "a73a7987fd803b11154e28a1da6a5d6dd9152ffc77a6531769d31872d1b56493"
    sha256 cellar: :any_skip_relocation, monterey:       "94b19b9e469907adb6a87c582f60e408cf7768e0ca9559943c6b54a0134533a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a34de49b0e3970f5e7ef95b118cc96ef9db29cece500cf91f48b53341a7fdbc8"
    sha256 cellar: :any_skip_relocation, catalina:       "29fd319cbaccaa116eec241aa8855d632e7c87f613135e254a1a0dbb594b5b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a0feae6285e6386b4727b8f141c2b99a8a451093e669dc719e9b83e89425c7d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/stern/stern/cmd.version=#{version}")

    # Install shell completion
    generate_completions_from_executable(bin/"stern", "--completion")
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
