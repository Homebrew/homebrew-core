class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https://superfile.netlify.app/"
  url "https://github.com/yorukot/superfile/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "bb394f73817d164b9756613ccd850fb3dd5fd5ee898defd86b27eecd4cec48bf"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cfacf24f1198669f8e0ff074c06449b8f96fa6480bd4e42adea6c0f77d8e232"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b89f425d6a6dedb21dfddc2fd5d47195ee600ec299ad095ee73e84d063d7a62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f70aaa2affc93c5b80ef4c667b4fb91c8ef105d95caf076437ca08f0384e80b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b49784c62f7b740bc1f0b485c901329dd683cc0aa57e312602559d876949ec2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "396adb5fd8b68a8ff359ca9b7921d8b49d3c396305125eca73eb5a1e21fd19ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f7279a9e28eb740bb19b7b2343dfda02d04f01da0c45bf987ad85906df5bafe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"spf")
  end

  test do
    # superfile is a GUI application
    assert_match version.to_s, shell_output("#{bin}/spf -v")
  end
end
