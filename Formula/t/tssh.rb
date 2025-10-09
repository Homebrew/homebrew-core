class Tssh < Formula
  desc "SSH Lightweight management tools"
  homepage "https://github.com/luanruisong/tssh"
  url "https://github.com/luanruisong/tssh/archive/refs/tags/2.1.3.tar.gz"
  sha256 "35b2b28eea5e41d6faa1e0eeee30ad18e069cc3489121257661097297692cd73"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33302c3e3fb3837451b9a03118795e19c863a4c65bb8e2dc440f31dab9833efe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d7c551460003a24a70c44899bbd8ed68eac573b75a926cf3a42b586b6517560"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d7c551460003a24a70c44899bbd8ed68eac573b75a926cf3a42b586b6517560"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d7c551460003a24a70c44899bbd8ed68eac573b75a926cf3a42b586b6517560"
    sha256 cellar: :any_skip_relocation, sonoma:        "93b16345f6977178f63810e9555df80443c00fae2e628a964cee8b3ffad8ab14"
    sha256 cellar: :any_skip_relocation, ventura:       "93b16345f6977178f63810e9555df80443c00fae2e628a964cee8b3ffad8ab14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89a41d4e35ebf5cd8ca7041757cd2cf85a39ca8316a3531006b79f7263a5c642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a870f0b129a69a7a1eeb04f2571065e7309bfc52421395ba6347206d4b8bc080"
  end

  depends_on "go" => :build

  conflicts_with "trzsz-ssh", because: "both install `tssh` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    output_v = shell_output("#{bin}/tssh -v")
    assert_match "version #{version}", output_v
    output_e = shell_output("#{bin}/tssh -e")
    assert_match "TSSH_HOME", output_e
  end
end
