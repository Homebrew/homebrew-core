class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.81.0.tar.gz"
  sha256 "8616e136efdb1fa97f3804f65037b21c90b469c6a29f51ab3924805cce1522b6"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fe56b6a3afd10dfb7913dc8230aaabef7a6c9ad204d356f18c1ffec006268a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4a154ec7e0d53fb6e5819f470ce29c42e365b2325a8bd676a50c814ca19e6d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3de62e760d4b3042b5b60628854b386a2dcc30ca82e0e0ae6d391c359b4f472"
    sha256 cellar: :any_skip_relocation, sonoma:        "59b3f4f31696fecbdd5ff4309dfd83b81c4faf8c9abad89287f6a9d3d06c5bce"
    sha256 cellar: :any_skip_relocation, ventura:       "fcce46bbe7411a661798ae0769f296ee31d511720632f245930ef40478d501b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7685496d19a4ba02ed2b1ae9010964679666ec1688b20c488b8e30ac4eea120a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "unsupported driver", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end
