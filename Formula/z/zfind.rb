class Zfind < Formula
  desc "Search for files (even inside tar/zip/7z/rar) using a SQL-WHERE filter"
  homepage "https://github.com/laktak/zfind"
  url "https://github.com/laktak/zfind/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "ea7a30b650a1f89afb39136d46386b009b44d7dbccc907f8aedf1c348b3bfd1a"
  license "MIT"
  head "https://github.com/laktak/zfind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aeff8d859dabf36b15008a7ad6f3f1de5d4f3c7c5788ab6dd1f33faeea5f4980"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99daa1d4245996b097f15073e30891ccf03cb9a2c71782111d3a631b1789ce16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f63953fafb04698a735faf1c53c9f578be108dd5b2b0ef96da93f6fb9410f51a"
    sha256 cellar: :any_skip_relocation, sonoma:         "29f989616731108dc11f0980bb8ffe687355f5fefafe7167916c7502595e0636"
    sha256 cellar: :any_skip_relocation, ventura:        "c3c63d0286a7989fea2e9f5719d2aa4a2717b31f659c4f7a8eeeb0a958cffe43"
    sha256 cellar: :any_skip_relocation, monterey:       "2fc656a62894ecfdb3c636d65b08bc6a986beabb6c4084c138c4e3a59053fa41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99af54ce193c5294db97fdaa017d834346206544abcb52ec6023d41535bbd50f"
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
