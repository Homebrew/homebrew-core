class SpawnFcgi < Formula
  desc "Spawn FastCGI processes"
  homepage "https://redmine.lighttpd.net/projects/spawn-fcgi"
  url "https://www.lighttpd.net/download/spawn-fcgi-1.6.5.tar.gz"
  sha256 "a72d7bf7fb6d1a0acda89c93d4f060bf77a2dba97ddcfecd00f11e708f592c40"
  license "BSD-3-Clause"
  head "https://git.lighttpd.net/lighttpd/spawn-fcgi.git", branch: "master"

  livecheck do
    url :head
    regex(/^(?:spawn-fcgi-)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4de0d3bcce309cbdc05bf9a6a26817b6387138d7277f7e2d7370cd1ad3084d5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b8901315c6c844b9111dbfd8c6d7ddfcb42369700137fca1e415f3099241775"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34d39121f6d102b995f16d7681ef5bbcf229212f4fff2ec26b8f8aba4140b40a"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb6d63cda1b37b7a8021c6cbd17283163b8ec27969557bea5661ad5c414358ce"
    sha256 cellar: :any_skip_relocation, ventura:        "0703018e4e309fc74951e5d53cb46e603f798d229cde3c55b5deaba9bb7dc552"
    sha256 cellar: :any_skip_relocation, monterey:       "a4dc94e1addab36efa0858be55e44c9944d7180f2f76d025498f9a4f61e59e27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72213bcf6bfdc11d458bd7cd7ce57a2b75dff10c4d9cc197c2eb6a25025afa25"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/spawn-fcgi", "--version"
  end
end
