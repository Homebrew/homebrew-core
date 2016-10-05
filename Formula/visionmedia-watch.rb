class VisionmediaWatch < Formula
  desc "Periodically executes the given command"
  homepage "https://github.com/visionmedia/watch"
  url "https://github.com/visionmedia/watch/archive/0.3.1.tar.gz"
  sha256 "769196a9f33d069b1d6c9c89e982e5fdae9cfccd1fd4000d8da85e9620faf5a6"

  head "https://github.com/visionmedia/watch.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2d0df99a4e8b377f064c393a4e349cf12374df139a3cf04f76dd8b69f2558d39" => :sierra
    sha256 "b43dbb305fcb6c681d2208456a1f39dd0aa5b97790b629ac907a666869119f20" => :el_capitan
    sha256 "4d31b501672801394c687aa45a44741f3461fb4730e96fe94197a1e7952fe2e0" => :yosemite
    sha256 "941cd639bf71a7d0e7397b77a3eebce4bd06fbc4ef30aac69147b04b3f6569f8" => :mavericks
  end

  conflicts_with "watch"

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end
end
