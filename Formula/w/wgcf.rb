class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/refs/tags/v2.2.22.tar.gz"
  sha256 "949cfc61681683ef44af9561bf8080ea87f04d4da00f97d0512143956b6e27b9"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0474d88c424348fa256ef25cd11a971843321fb0f6f1a7b3aca476282645063e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30b08ba9ea9bba13576d308b590e83a24c8d726ad26bf789e5649561d9f8588c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d1f5e645fac335f5e7d296c25f1cd8f0216f28f5bd2a089c64448bab2b36f64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "898ab52bb5a76c7e87f065025424a1451fd22e858d2a1c37613d3d5f5495af2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "f955d1961203097c9710145dbe6ee3ff49125a6c607c3b47a1ce9c46cb8e6253"
    sha256 cellar: :any_skip_relocation, ventura:        "3fa3f9a7a07c9dd655d7d417e7a9698048d59bc151209fc4e017ebc72ffa9fa1"
    sha256 cellar: :any_skip_relocation, monterey:       "67fd9c76a1804cdf0e82dd78a93ae8f97ab2571953fa733f4f8c0e88265ae755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1764cb6e43ab8a54f06bb33f0bfd1a24d9c91bd46e27678edb622a180fef3bc8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"wgcf", "completion")
  end

  test do
    system bin/"wgcf", "trace"
  end
end
