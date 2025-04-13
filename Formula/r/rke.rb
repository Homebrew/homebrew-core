class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rke.docs.rancher.com/"
  url "https://github.com/rancher/rke/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "fb6de7975795e6f023b6a13f138965215f6ae5939fe59fea981b4a356ddb1e1a"
  license "Apache-2.0"

  # It's necessary to check releases instead of tags here (to avoid upstream
  # tag issues) but we can't use the `GithubLatest` strategy because upstream
  # creates releases for more than one minor version (i.e., the "latest" release
  # isn't the newest version at times).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4499fc426ea1c4a7b25396a568c2dba4c243de2d33fdc01e15a75352396d25c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d30bf1bb368bbfc7aca2d81bd8299259c5fa3807db7a35885005e746a939c157"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d11463a1a0859729ccd8bd41de60078d8b1c1e689ec8009a332205e550bc4b71"
    sha256 cellar: :any_skip_relocation, sonoma:        "afae0a2546a11edbc8c60a775122c7edd40d8f391235130c1fcd0dc7f7b8a8ba"
    sha256 cellar: :any_skip_relocation, ventura:       "5e7b9ff67103be61450cab129a0acc9b30980faa55eb7005297c204484c07bcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "761fdda951f0c01a9e9e49b069a6a130a537613236c5eddd09a2ba35dd2cebbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72c59b094cff307187d2f04bb13b0c3db1bda74ee4cdd7bb04201ef0fe969daf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"rke", "config", "-e"
    assert_path_exists testpath/"cluster.yml"
  end
end
