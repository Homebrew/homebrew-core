class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.84.1.tar.gz"
  sha256 "455ee37bfef8afaa988913a40a99de740e89be5973e175e82122430560226c76"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af6edb3c13275d2a5327ffb6686d5a983c17fcf94b1f9552696171bf223efa09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82d26cbdef360d98e6f1de01bf3b512e77d0ea1de4fe007a71c79f832ed322cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4658911c37d5d771f94063df69f160aaea223dae72edd85211eff922b6db12c"
    sha256 cellar: :any_skip_relocation, sonoma:        "77932e72bd4329a520eedb2714a2ff2c1465b9f719098c7f8a0f4726399d280d"
    sha256 cellar: :any_skip_relocation, ventura:       "3ab4831f7cb7ba3c00760f57734031883dceec823c5c5d7b6b0b2ee781983279"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef90824ba943c8aa4e470532cdb7daaaa809b3964dabd9200572b79397695697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0c71f0f8c8adb39cb2acdf52d034931983729bc0137c9dbff9b6de6224d1228"
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
