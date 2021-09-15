class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.11.0.tar.gz"
  sha256 "95ebb3ac0215bf43d6cdf17d320e22601a3a7228d979e5a6cbaf8c4082f9ad22"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "daffa6a328e54eaf7de706a78d82d61747b8fb72e90c73b3cd5bdfe4fd410f89"
    sha256 cellar: :any_skip_relocation, big_sur:       "379a9307c825d9dc843e6e5df4a83786a462d48ba10022706810eeb720c91969"
    sha256 cellar: :any_skip_relocation, catalina:      "a81ca8fca7e773534d6eaf6f57dfa062d8e3cc28afb1035a0299efd35b31219f"
    sha256 cellar: :any_skip_relocation, mojave:        "68b0a67aeb9958226cd1434345e81ff54850212c841dd33d3d63ca30b8d8ca85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a860533d10f385c25b69e914424bd010d3c3e0b59d371afa5fe49c598723b5d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
