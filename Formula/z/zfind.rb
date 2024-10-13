class Zfind < Formula
  desc "Search for files (even inside tar/zip/7z/rar) using a SQL-WHERE filter"
  homepage "https://github.com/laktak/zfind"
  url "https://github.com/laktak/zfind/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "864571b556c724ae3bd7a0bff2dbcca9948df5c35ee0e97aca9172c1d662268e"
  license "MIT"
  head "https://github.com/laktak/zfind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "62de95628ba81890ef5683c13cf4cd041d985aba3bdda47a1388e1fb41a8a2e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f51c7884ff5a42d7234eb49c1d5fc6511cbfc8e3deb17746f6935c20bbba4f5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15b697113810db8a2fe10c25eb0e1f499fb16b4f249215b1d36b8197cef210f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "455702c964ea316bea2a60ba7590356ba2243bab7e93c06bd60f7a4315c9a89c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bcc0ee76867096334abee77aa42b3465890a0daf8ea825b615c213d83244dd7"
    sha256 cellar: :any_skip_relocation, ventura:        "b8f6d69da34277a46f2a6460754c0977af21b7a0dfbfa05ace7f4b6112b37e14"
    sha256 cellar: :any_skip_relocation, monterey:       "19e636e6c1f72117cc8c11e9757be9cf88ce5771bd9436fd4ef3a07595ea6d0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "802b817c6b91daf730d5cd18a003042c12f5b850b5744dd0fe45ae8926fd2a99"
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
