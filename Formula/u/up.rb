class Up < Formula
  desc "Tool for writing command-line pipes with instant live preview"
  homepage "https://github.com/akavel/up"
  url "https://github.com/akavel/up/archive/refs/tags/v0.4.tar.gz"
  sha256 "3ea2161ce77e68d7e34873cc80324f372a3b3f63bed9f1ad1aefd7969dd0c1d1"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "41660751b3b6db84af28af28f3debef5305f6076127c8e82084665b374a20790"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c337068ce52d195859c44c0f90e4f1264b2d10a87fd6a3616e7ba2949087c7be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a89c4913c0dca7e416bba8ef1cd30684f4ebc7a6f58061a3fa1d22fc91339d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f5a6065d0135d29db9a246ef73a18d6336ad72813783425cb6e109a93ea0a99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d956b1e6e6d9d1e76beadfdff52cce9bc0b7440813cd046cc96aa18324bc787a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3452e5a6d248a93e947fb5500bd7c5aad22fe77ad791b07c9fc7fe645b47170"
    sha256 cellar: :any_skip_relocation, sonoma:         "0be1b12cf1d9ba815952b51c8a12c712a201b73e56d41bf5d8b13c4d9333b21e"
    sha256 cellar: :any_skip_relocation, ventura:        "518b6745aef4837bb14288c365f26b448d0dbd76d47a996a9a9792330cad05c7"
    sha256 cellar: :any_skip_relocation, monterey:       "2b54cdd0bb6cb00c205dcfc1b1bd355513999a85e7213bbcac0823ca14f09f58"
    sha256 cellar: :any_skip_relocation, big_sur:        "48e91e5ef814e94a40749a9765a17eea031cc3e7b20edf4161187d454a1291da"
    sha256 cellar: :any_skip_relocation, catalina:       "1389b7f7a0c33f8563bacc20c09ba7781440a9fdd0b42a357a944e64dc65e3dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d7e2421c9736e3abffbea3612d9d0f4dfe513b6dd4b8ed27ff88f3ee4971d80f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9571f93607c8448f5dc5cc3cffa29dbd87c44f255d6339ca0c119d970f39b051"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "up.go"
  end

  test do
    assert_match "error", shell_output("#{bin}/up --debug 2>&1", 1)
    assert_path_exists testpath/"up.debug", "up.debug not found"
    assert_includes File.read(testpath/"up.debug"), "checking $SHELL"
  end
end
