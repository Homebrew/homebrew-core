class VisionmediaWatch < Formula
  desc "Periodically executes the given command"
  homepage "https://github.com/tj/watch"
  url "https://github.com/tj/watch/archive/0.4.0.tar.gz"
  sha256 "d37ead189a644661d219b566170122b80d44f235c0df6df71b2b250f3b412547"
  license "MIT"
  head "https://github.com/tj/watch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "483b9ff4d88bc672f1fbdaeecabda4c664f392efed8077af088449b5be541048"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40495ba873ac4427ecab5da7d30a23594efd23d27b26996045ba1a38c357f3ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4df49e42fc91ffb6991b43ce81c7b9e7d7f261bac48c712aac427f7e61385f4d"
    sha256 cellar: :any_skip_relocation, ventura:        "62cb611c93b182fddcfdb54a2e1053b1c1a8140046dca0f9737269d60bed5be6"
    sha256 cellar: :any_skip_relocation, monterey:       "f749ac37533097322fc34e946c16eb286a3eee82ac4d36125ebe29dc39f0c4e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9df96f9ac4ae658f41cc25dbbb863f1a9974cbe28cb0ef7b8efbb54751fd41cb"
    sha256 cellar: :any_skip_relocation, catalina:       "8a8d2389c8d830b692fdb2431a6414bfa68e80575b5cf303b81fc04ba851e5c8"
    sha256 cellar: :any_skip_relocation, mojave:         "8cb94f6e2c5faca9161daf2f8332862c7130ef2ac82f7b8258f5d927f40f5b11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dcfe8e94d71a7fd667ce896127b665675c2a4d18f04c8c3d317efe50e5ae68f"
  end

  conflicts_with "watch"

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end
end
