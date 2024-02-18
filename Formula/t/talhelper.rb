class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "7603128ee2bf246d826a8a22e09bb13c7be0ed5d9afb524df00a2c60cf90b388"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68cf21a3de208f43f0252e2f6b33f94d3cb682bd231c0713925219a74c110617"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da6c052449758f2de6aac44ac953e26846fb8b07dcc4370d6f6d18ad19dc5d63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b067789c2746e65e4860d5f96c26ed36cf68080c34c40c3868c9ade0d39cc167"
    sha256 cellar: :any_skip_relocation, sonoma:         "264741a8629dccb90fb8b465b5c304e37211d3af43379b069ff4837753503fd9"
    sha256 cellar: :any_skip_relocation, ventura:        "7ef9b034926aac2160db5e4da12ffac04c7ce3a1e4a4022c7f34269188aad2f9"
    sha256 cellar: :any_skip_relocation, monterey:       "bfdf66f15e500419d4598142804e5afb51757bbbbc00daf61724ea34621e8120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5346c76d986e6abce5fdcb4a04884436d78068b2c1e503a02300de91d1a996d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end
