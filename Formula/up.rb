class Up < Formula
  desc "Tool for writing command-line pipes with instant live preview"
  homepage "https://github.com/akavel/up"
  url "https://github.com/akavel/up/archive/v0.4.tar.gz"
  sha256 "3ea2161ce77e68d7e34873cc80324f372a3b3f63bed9f1ad1aefd7969dd0c1d1"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d956b1e6e6d9d1e76beadfdff52cce9bc0b7440813cd046cc96aa18324bc787a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3452e5a6d248a93e947fb5500bd7c5aad22fe77ad791b07c9fc7fe645b47170"
    sha256 cellar: :any_skip_relocation, monterey:       "2b54cdd0bb6cb00c205dcfc1b1bd355513999a85e7213bbcac0823ca14f09f58"
    sha256 cellar: :any_skip_relocation, big_sur:        "48e91e5ef814e94a40749a9765a17eea031cc3e7b20edf4161187d454a1291da"
    sha256 cellar: :any_skip_relocation, catalina:       "1389b7f7a0c33f8563bacc20c09ba7781440a9fdd0b42a357a944e64dc65e3dc"
    sha256 cellar: :any_skip_relocation, mojave:         "e9a517e8c51a5da04f070628b327a24344b8a7d093bee13cb1efa8ed6a8a944f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9571f93607c8448f5dc5cc3cffa29dbd87c44f255d6339ca0c119d970f39b051"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "up.go"
  end

  test do
    assert_match "error", shell_output("#{bin}/up --debug 2>&1", 1)
    assert_predicate testpath/"up.debug", :exist?, "up.debug not found"
    assert_includes File.read(testpath/"up.debug"), "checking $SHELL"
  end
end
