class RmImproved < Formula
  desc "Command-line deletion tool focused on safety, ergonomics, and performance"
  homepage "https://github.com/nivekuil/rip"
  url "https://github.com/nivekuil/rip/archive/0.13.1.tar.gz"
  sha256 "73acdc72386242dced117afae43429b6870aa176e8cc81e11350e0aaa95e6421"
  license "GPL-3.0-or-later"
  head "https://github.com/nivekuil/rip.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2294e77a9e860f573daf64e25bc53b6e2b32b6a565e0c727aa26321bb883c924"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afd393bdf6a0c370043d56d35787e4cc3f1d022bf4108a9f0684ba170586bebb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb348c7717ce6f299ca8b051eb425f9f2f07d9b436b81403e6098d61c3cb1549"
    sha256 cellar: :any_skip_relocation, ventura:        "072828a5ca46aaf0a0d8bc69ad769f9b9c6b89e4bfcd2a8ef83e0f48577f3847"
    sha256 cellar: :any_skip_relocation, monterey:       "a7f0bf8bd18d8408cf671da609422a5a8fa683f876ab641082b07933f7770756"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a80043be18665c37508e3f028ceeb0ec68cfba556ce5461d4f6575ec6b50076"
    sha256 cellar: :any_skip_relocation, catalina:       "91894b6d16374218d42457f7aa30a9a95572206e71328b52eaed159a51df0d15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "944efe35afd78abf0184654d4fbcc84b081d38c704021b5e964292016c917593"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    trash = testpath/"trash"
    ENV["GRAVEYARD"] = trash

    source_file = testpath/"testfile"
    deleted_file = Pathname.new File.join(trash, source_file)
    touch source_file

    system "rip", source_file
    assert_match deleted_file.to_s, shell_output("#{bin}/rip -s")
    assert_predicate deleted_file, :exist?

    system "rip", "-u", deleted_file
    assert_predicate source_file, :exist?
  end
end
