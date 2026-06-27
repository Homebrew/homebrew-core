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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9af57f6ad01333ac24e4ecc421eba5ee201f7a5302d56f501bb8e1494ac4e24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9af57f6ad01333ac24e4ecc421eba5ee201f7a5302d56f501bb8e1494ac4e24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9af57f6ad01333ac24e4ecc421eba5ee201f7a5302d56f501bb8e1494ac4e24"
    sha256 cellar: :any_skip_relocation, sonoma:        "624acdc72d44849936d334739c194c880319524091aeea753662f7445a63ff3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30df7166e091ecdd5e6cf92cd2d73d98eae728ec58e23ce7ccfd4f0ca231c29a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9005d0b0a2edd4d0661257b07d1d9ef0b5328718e0f2ca7caedaae48025df560"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/swctl"

    generate_completions_from_executable(bin/"swctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/swctl --version 2>&1")

    output = shell_output("#{bin}/swctl --display yaml service ls 2>&1", 1)
    assert_match "level=fatal msg=\"Post \\\"http://127.0.0.1:12800/graphql\\\"", output
  end
end
