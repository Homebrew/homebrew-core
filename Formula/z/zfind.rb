class Zfind < Formula
  desc "Search for files (even inside tar/zip/7z/rar) using a SQL-WHERE filter"
  homepage "https://github.com/laktak/zfind"
  url "https://github.com/laktak/zfind/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "cdd17b981e20eab9d8daa59883c37e4be22e95af0e72d273ab5f45ce683f106a"
  license "MIT"
  head "https://github.com/laktak/zfind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1cf9f46226b201e7410a6ebc03f5441e71a8f229b684498afff2f7ad50a39b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1cf9f46226b201e7410a6ebc03f5441e71a8f229b684498afff2f7ad50a39b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1cf9f46226b201e7410a6ebc03f5441e71a8f229b684498afff2f7ad50a39b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "86b76cc1e99b774107a095bb1cdac248eea06407d6c2efc13fcab461678fb076"
    sha256 cellar: :any_skip_relocation, ventura:       "86b76cc1e99b774107a095bb1cdac248eea06407d6c2efc13fcab461678fb076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37ddf89957ee7412d9e7bc9a3b71d0403fc615d4a972b71332faa6e059fddce0"
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
