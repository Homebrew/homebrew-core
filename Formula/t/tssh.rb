class Tssh < Formula
  desc "SSH Lightweight management tools"
  homepage "https://github.com/luanruisong/tssh"
  url "https://github.com/luanruisong/tssh/archive/refs/tags/2.1.4.tar.gz"
  sha256 "bbe8938b96c04aad5a843405a4414dde925f8827f29ac9c7d855d1bc84348b75"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44fa3c9ba54472a28312f3411920b57cd1279eb607bca1a71f1aeec3e45fd84b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44fa3c9ba54472a28312f3411920b57cd1279eb607bca1a71f1aeec3e45fd84b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44fa3c9ba54472a28312f3411920b57cd1279eb607bca1a71f1aeec3e45fd84b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5810f3b875548a049e3b59dff22ef18114783a8875f7d83106dcfdde3e40cfad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bf2c612ad29cb9719d3afae93b87e2ed62fb14925b0777a4c4c00c94faf179f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d92a59eaf31856c56126a1cfda5fff069a1bb7d4c3e12af3ab20b6a0fc6cc035"
  end

  depends_on "go" => :build

  conflicts_with "trzsz-ssh", because: "both install `tssh` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    output_v = shell_output("#{bin}/tssh -v")
    assert_match "version #{version}", output_v
    output_e = shell_output("#{bin}/tssh -e")
    assert_match "TSSH_HOME", output_e
  end
end
