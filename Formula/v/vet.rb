class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "bb399c825a8dc83dcf0da9aae4796aa1e1cfed6a1a1b88ad82619e5050de5e87"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99bea0ff6529a42b53b88a00e4da3280ee5090151d98160155129eb700da6f2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8aba9f343309d8561b89ada3834d169e7da2ac525cb268938fcbfe2daca509e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54b1558a867f8a623d6904432a249e9d65992ef766e5d8cfb3f4cf7a4b06c745"
    sha256 cellar: :any_skip_relocation, sonoma:        "461fcc6fda6c6fea2468eb756f765cbb4f54aa9c9aa53f9be0cc29fa893da8ae"
    sha256 cellar: :any_skip_relocation, ventura:       "68992e10e333174edb2df5f5f8071c4ed055b60bd7792a6725e7df16aa14f381"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f39a57b49ba2211c6397798717e3903405f2a51ee05bb9faab0c47e1cc7b2f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f9acec234911d8471bf8f3737cbff5a962e910fc27ca5ab6447e7cfc6efb245"
  end

  depends_on "go"

  def install
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
