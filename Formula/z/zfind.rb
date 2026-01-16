class Zfind < Formula
  desc "Search for files (even inside tar/zip/7z/rar) using a SQL-WHERE filter"
  homepage "https://github.com/laktak/zfind"
  url "https://github.com/laktak/zfind/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "49bc01da8446c8a97182f9794032d851614f0efc75b4f4810a114491a08d3bd4"
  license "MIT"
  head "https://github.com/laktak/zfind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9484b12aa34aabcad72ece4f46b0dd3bd97591c180a40363116d3e3f31c6244b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42a14d6e1ee0eb40c0309c893b877c1e7440796eaf7209db195c576362f096e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42a14d6e1ee0eb40c0309c893b877c1e7440796eaf7209db195c576362f096e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42a14d6e1ee0eb40c0309c893b877c1e7440796eaf7209db195c576362f096e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f91bac0d8be49b7de9c64e288c9e8ce3430202d7fa6f258255fa97242dc52786"
    sha256 cellar: :any_skip_relocation, ventura:       "f91bac0d8be49b7de9c64e288c9e8ce3430202d7fa6f258255fa97242dc52786"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac0501815e21e830c29c41970de83f98ae716601343d65e94a61aa56e4963d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f07a3ba2af17209191e615c27b235be99fc748fba24f932b15d6005b588a6fb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zfind"
  end

  test do
    output = shell_output("#{bin}/zfind --csv")
    assert_match "name,path,container,size,date,time,ext,ext2,type,archive", output

    assert_match version.to_s, shell_output("#{bin}/zfind --version")
  end
end
