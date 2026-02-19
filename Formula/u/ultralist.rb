class Ultralist < Formula
  desc "Simple GTD-style task management for the command-line"
  homepage "https://ultralist.io"
  url "https://github.com/gammons/ultralist/archive/refs/tags/1.7.0.tar.gz"
  sha256 "d4a524c94c1ea4a748711a1187246ed1fd00eaaafd5b8153ad23b42d36485f79"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "cf20c183b0f002e46e7120e832512041e727cf95055558a4883081888df4daa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "110edc14d3b119a73a5de437726450fb928f436c94743d94db437bfe132b37be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b2752e4eb0dd8af2d061318320c6c9efe9b9668ffbf87349bc7d0a0517b590b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b299b08dcd7d0729ab4a7d5ed7b236c1d63d33ee4d67c64c313a604995303430"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad84b05d81e36133f2f57f72b0da8997b96e30d0b12122bb563e8e012d724271"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a2604f11a36ecf612bfd2912cd1b1a1345ea70995e884d156d935663150cbf9"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b8e53935f5471c24002269aa8e31a50553dfb4b691fd0f246eb241e64d8a63d"
    sha256 cellar: :any_skip_relocation, ventura:        "f038715abbc33eb9fb530e784c0a53406c251f71af164c601dfe7fba3d7cee57"
    sha256 cellar: :any_skip_relocation, monterey:       "e400736305be6718a828515079c72ab56f3ee8257672945f0a18c9a435a43ccc"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1c9c3e4f51dcec7c482a44e9111fdb3bf42081195d73df63c858c8c60a66eb0"
    sha256 cellar: :any_skip_relocation, catalina:       "529daa8fdf264f4f13f8f93d785095d4a803f94902772e25094415691bf7f83c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "eb37076414ad6dfb8788d0a12a0cbc3db6d1429a7bb2d3b8c664f11ef2587184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1d287b06c14adcd326d8dd626209fcfa7a287919dce6f755f80a6513b2ed6e7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"ultralist", "init"
    assert_path_exists testpath/".todos.json"
    add_task = shell_output("#{bin}/ultralist add learn the Tango")
    assert_match(/Todo.* added/, add_task)
  end
end
