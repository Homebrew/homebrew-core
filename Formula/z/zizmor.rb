class Zizmor < Formula
  desc "Find security issues in GitHub Actions setups"
  homepage "https://github.com/woodruffw/zizmor"
  url "https://github.com/woodruffw/zizmor/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "257ff8b1bf203d329d719db651a7b1c6847ef572c0e3d714fb0d642ff094f13a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e23c1c6b5794c9dda66eb364b1354026369c2fe016733f9f3758b887bc938c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb44545d1705919843996e9aadefd0c2280648a92bb7ec4d65f2e75f38dc7964"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d199519302d7c56f167b330346eca0010f382cec08cc94ddc267bb543bcda3f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a78c3095ead85c5975a2c06335ae5bedea81d0c2691ee7c86c3a1b661d752967"
    sha256 cellar: :any_skip_relocation, ventura:       "9c745dc28be8de604f75e56378d94316e8072df5bae011cb65f33af1cf3d93fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4325674d9a36abe58edf45267efe89af4b837a91f8758a302f55ea98ae6002d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"action.yaml").write <<~YAML
      on: push
      jobs:
        vulnerable:
          runs-on: ubuntu-latest
          steps:
            - name: Checkout
              uses: actions/checkout@v4
    YAML

    output = shell_output("#{bin}/zizmor --format plain #{testpath}/action.yaml", 13)
    assert_match "does not set persist-credentials: false", output
  end
end
