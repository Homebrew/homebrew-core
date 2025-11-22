class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.12.8.tar.gz"
  sha256 "c96c025c8bc59214005301b54c25da07bc2e010be198efba41fa94e55c5a0071"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1aae293c5859e569f0ec996470657bef89857d5607bf3eda2a0a4d136b82ec4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9e411d0991e3d69b868d0f48dedf21fde0273c28203426df5ebda15e13a2b0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b30a94c59537a54f9c9230e381cdb9817e5528f22ef51bd0b819cafab07b47da"
    sha256 cellar: :any_skip_relocation, sonoma:        "05a92b82e39b4d7432831956802594ff5c3795cd2b2db30c1385c28137676b9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2f25084a9d120975587805ed6d7faf469e77af875104813fcc32ed2fefb7942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bacaa3b385fca94124b7cefa576a4e72e76a400636597a731f52fc5c806e1b14"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
