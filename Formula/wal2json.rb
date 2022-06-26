class Wal2json < Formula
  desc "Convert PostgreSQL changesets to JSON format"
  homepage "https://github.com/eulerto/wal2json"
  url "https://github.com/eulerto/wal2json/archive/wal2json_2_4.tar.gz"
  sha256 "87e627cac2d86f7203b1580a78b51e1da8aa61bb0af9ebfa14435370f3878237"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:wal2json[._-])?v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "562c8d9b754cca6f4ec3c96159f622d1aa0e495e6c96356733aa6bd74ff6536a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45d6b3f62b30281f54c34a045977f99b7abc2183b3b36ab3a4652a8f53ade698"
    sha256 cellar: :any_skip_relocation, monterey:       "3a2926a52fe9aa779a85d765739eefcccf29b65736546756d4e806ce366e0bf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d738e9dfcd5e546388697263c28b5fba8d93ab9e9cbd8fc4761506cab2444c2a"
    sha256 cellar: :any_skip_relocation, catalina:       "52971794eb21cd96a1abdac41073544ecf42008fd2fa61724996c674771e0d36"
    sha256 cellar: :any_skip_relocation, mojave:         "65bc96789f47c2d9c2afb74dd60d6b63242454440f8da2612edef3a9fb899e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e390370160cf6213efc8b3436d544a2c48d82c47404a243ed7a384940ce53ea6"
  end

  depends_on "postgresql"

  def install
    mkdir "stage"
    system "make", "install", "USE_PGXS=1", "DESTDIR=#{buildpath}/stage"
    lib.install Dir["stage/#{HOMEBREW_PREFIX}/lib/*"]
  end
end
