class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https://github.com/vultr/vultr-cli"
  url "https://github.com/vultr/vultr-cli/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "f0aa3f641c8be1278824c1d1a44670cb18ea236d91776a60d27bafb25372137e"
  license "Apache-2.0"
  head "https://github.com/vultr/vultr-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dcf67300aacbc1b852a98f4035394ce5a8719a25eb1ff91c910fcb68436327a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d68772668ef95b473c5bdc67e5d8ab34782aed2c0a925e83cff7bad02e289e44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9a0785308c7629bd01a57abc8c4c0547983d9c5f0530ae87512e113642cea6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5593a571707f05dbaf50f5bff0e40654a9471398ed46c98dbad38351f5aea503"
    sha256 cellar: :any_skip_relocation, ventura:        "1539c9778c983dcf7f7252ded334ea3746e5d7197f60f92122235fe705663f83"
    sha256 cellar: :any_skip_relocation, monterey:       "7591fa5a342c9a5971584c0ea952425b4b353d82e68daa87ccdc2037a14c19ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cedf3e45b5acb513a5a9f12825dabf892f0e7aafe8dbbfd6052fb470dcb05c5c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"vultr", "version"
  end
end
