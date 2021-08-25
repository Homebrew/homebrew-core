class VisionmediaWatch < Formula
  desc "Periodically executes the given command"
  homepage "https://github.com/visionmedia/watch"
  url "https://github.com/visionmedia/watch/archive/0.3.1.tar.gz"
  sha256 "769196a9f33d069b1d6c9c89e982e5fdae9cfccd1fd4000d8da85e9620faf5a6"
  head "https://github.com/visionmedia/watch.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "de9f199c6b0015442f2068dc205513b1631af9a18cab544aba1b2f6b052ad9fe"
    sha256 cellar: :any_skip_relocation, big_sur:       "4bcf3455efe0663ac6cf7e1cecc7034be3081496e5f4b466435c91f0c4aa5cae"
    sha256 cellar: :any_skip_relocation, catalina:      "2b74d2ac31359ec62371784e3136d9ba06e2fc29ba3dd1023cce286c865a5eef"
    sha256 cellar: :any_skip_relocation, mojave:        "03a1d48222a068e547401e4d37c702fe5d15ce05d625c9a41c356be8ee70c4d6"
    sha256 cellar: :any_skip_relocation, high_sierra:   "8214381e2ca4562345192b1b88a732f2f8fdfbfc3d107649c652e2985be4ef52"
    sha256 cellar: :any_skip_relocation, sierra:        "2d0df99a4e8b377f064c393a4e349cf12374df139a3cf04f76dd8b69f2558d39"
    sha256 cellar: :any_skip_relocation, el_capitan:    "b43dbb305fcb6c681d2208456a1f39dd0aa5b97790b629ac907a666869119f20"
    sha256 cellar: :any_skip_relocation, yosemite:      "4d31b501672801394c687aa45a44741f3461fb4730e96fe94197a1e7952fe2e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e82a88a59028602931d4e41d3b67372d5693cea67242bd3525a600c2fd6a8307"
  end

  conflicts_with "watch"

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end
end
