class Swctl < Formula
  desc "Apache SkyWalking CLI (Command-line Interface)"
  homepage "https://skywalking.apache.org/"
  license "Apache-2.0"
  head "https://github.com/apache/skywalking-cli.git", branch: "master"

  stable do
    url "https://github.com/apache/skywalking-cli/archive/refs/tags/0.14.0.tar.gz"
    sha256 "9b1861a659e563d2ba7284ac19f3ae72649f08ac7ff7064aee928a7df2cd2bff"

    # fish and zsh completion support patch, upstream pr ref, https://github.com/apache/skywalking-cli/pull/207
    patch do
      url "https://github.com/apache/skywalking-cli/commit/3f9cf0e74a97f16d8da48ccea49155fd45f2d160.patch?full_index=1"
      sha256 "dd17f332f86401ef4505ec7beb3f8863f13146718d8bdcf92d2cc2cdc712b0ec"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fa1d27d8a0f4f54259a1747dc4ce19075d0c91313a0d5d6218f3059ac9bc694"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59d564281b8144703d6f13370a3f725a6db5b342e66906ed28b860931bf71d15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59d564281b8144703d6f13370a3f725a6db5b342e66906ed28b860931bf71d15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59d564281b8144703d6f13370a3f725a6db5b342e66906ed28b860931bf71d15"
    sha256 cellar: :any_skip_relocation, sonoma:        "391feee4582cf497126e59ce27dd4041b311b1da788b5c38c64cc44811d93921"
    sha256 cellar: :any_skip_relocation, ventura:       "391feee4582cf497126e59ce27dd4041b311b1da788b5c38c64cc44811d93921"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0244a2e3e667dbcdebf3997f1c223d1422ea02166d0b80066c33334191325ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56bdee16710d22095c1fd118f8ac5a116b25ac3c7d541cad4b365eae4c665eaa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/swctl"

    generate_completions_from_executable(bin/"swctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/swctl --version 2>&1")

    output = shell_output("#{bin}/swctl --display yaml service ls 2>&1", 1)
    assert_match "level=fatal msg=\"Post \\\"http://127.0.0.1:12800/graphql\\\"", output
  end
end
