class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/refs/tags/v2.2.22.tar.gz"
  sha256 "949cfc61681683ef44af9561bf8080ea87f04d4da00f97d0512143956b6e27b9"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21fb96a958e1856fd50f931e754d476d7ae4a62c677b39d2d47aa13d05818365"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b968eb88b3cf11850ae9470f95f397c48dc27bcba5c5d59cabae32cfdd82c16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86ac8de322beb337ec1da45a559e2bbbecafb1646b00be7c0258853f9dc898de"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ae8bbeda888853ae82ca04a656c2211884379dc79d250f3fccce72d4189acc4"
    sha256 cellar: :any_skip_relocation, ventura:        "6c0665d7c41096149b5d4c2404d2300a6cd6230a6706c94d5a3d26c7ebc0aa71"
    sha256 cellar: :any_skip_relocation, monterey:       "90e2fb7931e4bf5ad88260ffcc4958bacebd8961e7c9fd644655314fb6377246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c9748c7310dbb79d844ce39b3b24c5e7ba770c6cd24cbf22b3cb05fb24fc404"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"wgcf", "completion")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
