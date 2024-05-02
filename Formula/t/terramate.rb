class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "9b37f3ac23d4293a96ae00b79b05774193e4d04b2b8f00b37933a90eac580534"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de88e3bd91b97cfeed0e69b80fcbb500f19783a99c7216ffb08c643ca6f9b683"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dff5f03d0685cec9be71c450b3ace1d791b08b02924f8f410bb7c11d27d69bc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72cce813bd6646373b22393928e24aeee77b50e253e37dab941c0b43c8b9f0c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea15c3dd15ebedbb99a60ffb5a7604306161a83cbae18e8bcedfd13d647170df"
    sha256 cellar: :any_skip_relocation, ventura:        "5d0df27ea18cab803709a30223869820e41b43860a0f040b3835b0515fe2eda5"
    sha256 cellar: :any_skip_relocation, monterey:       "d414586569b53d15df55089ffd7bdc941b3b363387c6390d713bd9f1c0cd5a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dc4f7aa8121b30711daff97be893d8764280cf2e9507f178d401cfd959b45d5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
