class Tssh < Formula
  desc "SSH Lightweight management tools"
  homepage "https://github.com/luanruisong/tssh"
  url "https://github.com/luanruisong/tssh/archive/refs/tags/2.1.3.tar.gz"
  sha256 "35b2b28eea5e41d6faa1e0eeee30ad18e069cc3489121257661097297692cd73"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "31d5aae46438b31a64f0180c4e85209be87bdc04329b8be903421839c1eb0c77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "675c209d949dae840b6e1d4dcd88a4e0648de30c3218385ee91a33a6b3025d92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "803bd66d7a62902c626f5688ce3e1ff1e99ddb0fcf795a017c677cf932dd07b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06ccc267f02e918cedea479f264ea4c245ea63ef6daa90a3ce18b93d5ec4fcfd"
    sha256 cellar: :any_skip_relocation, sonoma:         "a11ae3d3ba7975b94a207ec04f876fb0d33b1b9c1bcf435fa48e42a772944e09"
    sha256 cellar: :any_skip_relocation, ventura:        "63ab4bb6c51049e455207a18ca95190cbc930f02d02dc3c03c587d73af678cdf"
    sha256 cellar: :any_skip_relocation, monterey:       "3aab59e9bd9bbc5ac7099ea9647110d231523a262e4926e3c72d5651eb318368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f57b259db76e3ad735806dc67e8e73fbb737106c41a48c3307b50ba0c9a27934"
  end

  depends_on "go" => :build

  conflicts_with "trzsz-ssh", because: "both install `tssh` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    output_v = shell_output("#{bin}/tssh -v")
    assert_match "version #{version}", output_v
    output_e = shell_output("#{bin}/tssh -e")
    assert_match "TSSH_HOME", output_e
  end
end
