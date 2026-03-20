class Svu < Formula
  desc "Semantic version utility"
  homepage "https://github.com/caarlos0/svu"
  url "https://github.com/caarlos0/svu/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "7448fafc958551e06ad7c8bb2eddc5db9bd5d7335a7d5c80750193b68b6f78bd"
  license "MIT"
  head "https://github.com/caarlos0/svu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2cb5cf9e7e3a54ac0305ba6b92bc6579b00806940ee1b4bcb35ebb80949479a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2cb5cf9e7e3a54ac0305ba6b92bc6579b00806940ee1b4bcb35ebb80949479a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2cb5cf9e7e3a54ac0305ba6b92bc6579b00806940ee1b4bcb35ebb80949479a"
    sha256 cellar: :any_skip_relocation, sonoma:        "71e37771b8a1f26f2171dd64b6c06d6b2fb575265b234f1bce6169c5df6545f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb6fc6f24f354b2784e272ce6e3ff82f9cf47b26de6d9b11b0da4514c6e9ee54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cddc90ff2dec26b876cd70a333c71f69d47163402eeb2ad3cb2018fecc75bbb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user} -X main.treeState=clean"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"svu", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/svu --version")
    system bin/"svu", "init"
    assert_match "svu configuration", (testpath/".svu.yml").read
  end
end
